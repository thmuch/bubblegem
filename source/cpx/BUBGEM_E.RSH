/* GEM Resource C Source */

#include <portab.h>
#include <aes.h>
#include "BUBGEM_E.H"

#if !defined(WHITEBAK)
#define WHITEBAK    0x0040
#endif
#if !defined(DRAW3D)
#define DRAW3D      0x0080
#endif

#define FLAGS9  0x0200
#define FLAGS10 0x0400
#define FLAGS11 0x0800
#define FLAGS12 0x1000
#define FLAGS13 0x2000
#define FLAGS14 0x4000
#define FLAGS15 0x8000
#define STATE8  0x0100
#define STATE9  0x0200
#define STATE10 0x0400
#define STATE11 0x0800
#define STATE12 0x1000
#define STATE13 0x2000
#define STATE14 0x4000
#define STATE15 0x8000

TEDINFO rs_tedinfo[] =
{ "COPYRIGHT \2751998-03-04 THOMAS MUCH",
  "\0",
  "\0",
  SMALL, 0, TE_CNTR , 0x1100, 0, -1, 34, 1
};

OBJECT rs_object[] =
{ 
  /******** Tree 0 BGMAIN ****************************************************/
        -1, BGMFRAME        , BGMOK           , G_BOX             ,   /* Object 0  */
  FLAGS10, NORMAL, (LONG)0x00001100L,
  0x0000, 0x0000, 0x0020, 0x000B,
  BGMSAVE         ,        2, BGMSENDKEY      , G_BUTTON          ,   /* Object 1 BGMFRAME */
  FLAGS10, WHITEBAK|STATE9|STATE10|STATE11|STATE12|STATE13|STATE14|STATE15, (LONG)" BubbleGEM Configuration ",
  0x0001, 0x0800, 0x001E, 0x0008,
  BGMBUBBLES      ,       -1,       -1, G_TEXT            ,   /* Object 2  */
  NONE, NORMAL, (LONG)&rs_tedinfo[0],
  0x0000, 0x0001, 0x001E, 0x0001,
  BGMWINSTYLE     ,       -1,       -1, G_BUTTON          ,   /* Object 3 BGMBUBBLES */
  SELECTABLE|RBUTTON|FLAGS9|FLAGS10, WHITEBAK|STATE14|STATE15, (LONG)"Balloons",
  0x0002, 0x0802, 0x001A, 0x0001,
  BGMFONTCHANGED  ,       -1,       -1, G_BUTTON          ,   /* Object 4 BGMWINSTYLE */
  SELECTABLE|RBUTTON|FLAGS9|FLAGS10, WHITEBAK|STATE14|STATE15, (LONG)"Windows style",
  0x0002, 0x0803, 0x001A, 0x0001,
  BGMSENDKEY      ,       -1,       -1, G_BUTTON          ,   /* Object 5 BGMFONTCHANGED */
  SELECTABLE|FLAGS9|FLAGS10, WHITEBAK|STATE14|STATE15, (LONG)"accept Font protocol",
  0x0002, 0x0005, 0x001A, 0x0001,
  BGMFRAME        ,       -1,       -1, G_BUTTON          ,   /* Object 6 BGMSENDKEY */
  SELECTABLE|FLAGS9|FLAGS10, WHITEBAK|STATE14|STATE15, (LONG)"send AV_SENDKEY",
  0x0002, 0x0006, 0x001A, 0x0001,
  BGMCANCEL       ,       -1,       -1, G_BUTTON          ,   /* Object 7 BGMSAVE */
  SELECTABLE|EXIT|FLAGS9|FLAGS10, NORMAL, (LONG)"Save",
  0x0201, 0x0809, 0x0008, 0x0101,
  BGMOK           ,       -1,       -1, G_BUTTON          ,   /* Object 8 BGMCANCEL */
  SELECTABLE|EXIT|FLAGS9|FLAGS10, NORMAL, (LONG)"Cancel",
  0x060C, 0x0809, 0x0008, 0x0101,
         0,       -1,       -1, G_BUTTON          ,   /* Object 9 BGMOK */
  SELECTABLE|DEFAULT|EXIT|LASTOB|FLAGS9|FLAGS10, NORMAL, (LONG)"OK",
  0x0616, 0x0809, 0x0008, 0x0101
};

OBJECT *rs_trindex[] =
{ &rs_object[0]    /* Tree  0 BGMAIN           */
};
