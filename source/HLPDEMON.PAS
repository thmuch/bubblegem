{***************************************
 * BubbleGEM-Help-D„mon by Thomas Much *
 ***************************************
 *   Dieses Programm ist Freeware!     *
 ***************************************
 *    Thomas Much, Gerwigstraže 46,    *
 * 76131 Karlsruhe, Fax (0721) 622821  *
 *         Thomas Much @ KA2           *
 *  Thomas.Much@stud.uni-karlsruhe.de  *
 ***************************************
 *    erstellt am:        17.12.1997   *
 *    letztes Update am:  04.03.1998   *
 ***************************************}

{$B+,D-,G-,I-,L-,N-,P-,Q-,R-,S-,T-,V-,X+,Z-}

{$M 4096}

program BubbleGEM;

uses

	Tos,Gem;

const

	BUBBLEGEM_REQUEST   = integer($baba);
	
	BGHD_ACTIVE         = $0001;
	
	BGHD_COOKIE_DEFAULT = BGHD_ACTIVE;

	_p_cookies          = $000005a0;

type

	PLongint = ^longint;

	TCookieID = array [0..3] of char;

	PCookie = ^TCookie;
	TCookie = record
		ID   : TCookieID;
		Value: longint
	end;

	PBGEM = ^TBGEM;
	TBGEM = record
		magic  : array [0..3] of char;
		size   : longint;
		release: integer;
		active : integer;
		mhelp  : MFORMPtr;
		{ private }
		helpcrs: MFORM;
	end;

label

	_weiter;

var

	apID,
	winID,
	dummy,
	ownerID,
	mX,mY,
	BStat,
	KStat,
	event,
	evntmask,
	oldX,
	oldY    : integer;
	cval,
	timer   : longint;
	pipe    : ARRAY_8;
	bgem    : PBGEM;
	oldvalid,
	active,
	wfowner,
	has_agi : boolean;
	olddata : record
		mX,
		mY: integer;
	end;



function appl_xgetinfo(ap_gtype: integer; var ap_gout1,ap_gout2,ap_gout3,ap_gout4: integer): boolean;

	begin
		appl_xgetinfo:=false;
		if has_agi then
			with AES_pb do
				begin
					control^[0]:=130;
					control^[1]:=1;
					control^[2]:=5;
					control^[3]:=0;
					control^[4]:=0;
					intin^[0]:=ap_gtype;
					_crystal(@AES_pb);
					if intout^[0]=1 then
						begin
							ap_gout1:=intout^[1];
							ap_gout2:=intout^[2];
							ap_gout3:=intout^[3];
							ap_gout4:=intout^[4];
							appl_xgetinfo:=true
						end
				end
	end;


function HeapFunc(size: longint): integer;

  begin
    HeapFunc:=1
  end;


function getjar: longint;

	begin
		getjar:=PLongint(_p_cookies)^
	end;


function GetCookieJar: PCookie;

	begin
		GetCookieJar:=PCookie(supexec(getjar))
	end;


function GetCookie(cookie: TCookieID; var wert: longint): boolean;
  var cookiejar: PCookie;

  begin
  	GetCookie:=false;
    cookiejar:=GetCookieJar;
    if cookiejar<>nil then
			while PLongint(cookiejar)^<>0 do
				with cookiejar^ do
					if ID=cookie then
						begin
							wert:=Value;
							GetCookie:=true;
							exit
						end
					else
						inc(longint(cookiejar),8)
  end;


function NewCookie(cookie: TCookieID; wert: longint): boolean;
	var cookiejar: PCookie;
	    anz,maxc : longint;

	begin
		NewCookie:=false;
		cookiejar:=GetCookieJar;
		if cookiejar<>nil then
			begin
				anz:=1;
				while PLongint(cookiejar)^<>0 do
					begin
						inc(longint(cookiejar),8);
						inc(anz)
					end;
				maxc:=cookiejar^.Value;
				if anz<maxc then
					begin
						with cookiejar^ do
							begin
								ID:=cookie;
								Value:=wert
							end;
						inc(longint(cookiejar),8);
						with cookiejar^ do
							begin
								ID:=#0#0#0#0;
								Value:=maxc
							end;
						NewCookie:=true
					end
			end
	end;


procedure InitDemon;
	var dummy,
	    q,
	    check: integer;
	    cmdv,
	    valid: boolean;

	begin
		HeapError:=@HeapFunc;
		GEM_pb.global[0]:=0;
		apID:=appl_init;
		if GEM_pb.global[0]=0 then halt;
	  if apID<0 then halt;
	  if (GEM_pb.global[0]>=$0400) and AppFlag then menu_register(apID,'  Hilfe-D„mon ');
    menu_register(-1,'HLPDEMON');
    timer:=500;
    cmdv:=false;
    if ParamCount>1 then
    	for q:=1 to ParamCount-1 do
    		if ParamStr(q)='-t' then
    			begin
						val(ParamStr(q+1),timer,dummy);
						cmdv:=true;
		    		break
		    	end;
		has_agi:=(GEM_pb.global[0]>=$0400) or (appl_find('?AGI')=0);
		if appl_xgetinfo(10,check,dummy,dummy,dummy) then
			valid:=((check and $00ff)>=9) or (GEM_pb.global[0]=$0399)
		else
			valid:=(GEM_pb.global[0]>=$0400);
		if valid then shel_write(9,1,0,'','');
		if appl_xgetinfo(11,check,dummy,dummy,dummy) then wfowner:=((check and $0010)>0)
		else
			wfowner:=false;
		evntmask:=MU_MESAG;
		if wfowner then
			begin
				if not(GetCookie('BGHD',cval)) then
					begin
						NewCookie('BGHD',(timer shl 16) or BGHD_COOKIE_DEFAULT);
						active:=true
					end
				else
					begin
						if not(cmdv) then timer:=(cval shr 16) and $7fff;
						active:=((cval and BGHD_ACTIVE)>0)
					end;
				if active then evntmask:=evntmask or MU_TIMER;
			end;
		oldX:=-1;
		oldY:=-1;
		oldvalid:=false
	end;


begin
	InitDemon;
	repeat
		event:=evnt_multi(evntmask,0,0,0,0,0,0,0,0,0,0,0,0,0,pipe,timer,0,dummy,dummy,dummy,dummy,dummy,dummy);
		if (event and MU_MESAG)>0 then
			case pipe[0] of
			AP_TERM:
				begin
					appl_exit;
					halt
				end;
			BUBBLEGEM_REQUEST:
				if GetCookie('BGHD',cval) then
					begin
						timer:=(cval shr 16) and $7fff;
						active:=((cval and BGHD_ACTIVE)>0);
						if not(active) then evntmask:=evntmask and not(MU_TIMER)
						else
							if wfowner then evntmask:=evntmask or MU_TIMER;
						oldvalid:=false
					end;
			end;
		if (event and MU_TIMER)>0 then
			if active then
				begin
					wind_update(BEG_UPDATE);
					graf_mkstate(mX,mY,BStat,KStat);
					if (BStat and 3)=0 then
						if (mX=oldX) then
							if (mY=oldY) then
								begin
									winID:=wind_find(mX,mY);
									if winID>=0 then
										begin
											wind_get(winID,WF_OWNER,ownerID,dummy,dummy,dummy);
											if ownerID>=0 then
												if GetCookie('BGEM',longint(bgem)) then
													if bgem<>nil then
														if bgem^.active=0 then
															begin
																if oldvalid then
																	if (olddata.mX=mX) then
																		if (olddata.mY=mY) then goto _weiter;
																pipe[0]:=BUBBLEGEM_REQUEST;
																pipe[1]:=apID;
																pipe[2]:=0;
																pipe[3]:=winID;
																pipe[4]:=mX;
																pipe[5]:=mY;
																pipe[6]:=KStat;
																pipe[7]:=0;
																appl_write(ownerID,16,@pipe);
																olddata.mX:=mX;
																olddata.mY:=mY;
																oldvalid:=true
															end
										end
								end;
					_weiter:
					oldX:=mX;
					oldY:=mY;
					wind_update(END_UPDATE)
				end;
	until false
end.