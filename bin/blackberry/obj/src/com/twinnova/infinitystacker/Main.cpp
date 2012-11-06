#include <hxcpp.h>

#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_com_twinnova_infinitystacker_Main
#include <com/twinnova/infinitystacker/Main.h>
#endif
#ifndef INCLUDED_neash_display_CapsStyle
#include <neash/display/CapsStyle.h>
#endif
#ifndef INCLUDED_neash_display_DisplayObject
#include <neash/display/DisplayObject.h>
#endif
#ifndef INCLUDED_neash_display_DisplayObjectContainer
#include <neash/display/DisplayObjectContainer.h>
#endif
#ifndef INCLUDED_neash_display_Graphics
#include <neash/display/Graphics.h>
#endif
#ifndef INCLUDED_neash_display_IBitmapDrawable
#include <neash/display/IBitmapDrawable.h>
#endif
#ifndef INCLUDED_neash_display_InteractiveObject
#include <neash/display/InteractiveObject.h>
#endif
#ifndef INCLUDED_neash_display_JointStyle
#include <neash/display/JointStyle.h>
#endif
#ifndef INCLUDED_neash_display_LineScaleMode
#include <neash/display/LineScaleMode.h>
#endif
#ifndef INCLUDED_neash_display_MovieClip
#include <neash/display/MovieClip.h>
#endif
#ifndef INCLUDED_neash_display_Sprite
#include <neash/display/Sprite.h>
#endif
#ifndef INCLUDED_neash_display_Stage
#include <neash/display/Stage.h>
#endif
#ifndef INCLUDED_neash_display_StageAlign
#include <neash/display/StageAlign.h>
#endif
#ifndef INCLUDED_neash_display_StageScaleMode
#include <neash/display/StageScaleMode.h>
#endif
#ifndef INCLUDED_neash_events_Event
#include <neash/events/Event.h>
#endif
#ifndef INCLUDED_neash_events_EventDispatcher
#include <neash/events/EventDispatcher.h>
#endif
#ifndef INCLUDED_neash_events_IEventDispatcher
#include <neash/events/IEventDispatcher.h>
#endif
#ifndef INCLUDED_nme_Lib
#include <nme/Lib.h>
#endif
namespace com{
namespace twinnova{
namespace infinitystacker{

Void Main_obj::__construct()
{
HX_STACK_PUSH("Main::new","com/twinnova/infinitystacker/Main.hx",23);
{
	HX_STACK_LINE(24)
	super::__construct();
	HX_STACK_LINE(28)
	this->addEventListener(::neash::events::Event_obj::ADDED_TO_STAGE,this->init_dyn(),null(),null(),null());
}
;
	return null();
}

Main_obj::~Main_obj() { }

Dynamic Main_obj::__CreateEmpty() { return  new Main_obj; }
hx::ObjectPtr< Main_obj > Main_obj::__new()
{  hx::ObjectPtr< Main_obj > result = new Main_obj();
	result->__construct();
	return result;}

Dynamic Main_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< Main_obj > result = new Main_obj();
	result->__construct();
	return result;}

Void Main_obj::init( Dynamic e){
{
		HX_STACK_PUSH("Main::init","com/twinnova/infinitystacker/Main.hx",33);
		HX_STACK_THIS(this);
		HX_STACK_ARG(e,"e");
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(Main_obj,init,(void))

int Main_obj::SQUARE_WIDTH;

Void Main_obj::main( ){
{
		HX_STACK_PUSH("Main::main","com/twinnova/infinitystacker/Main.hx",38);
		HX_STACK_LINE(39)
		::neash::display::Stage stage = ::nme::Lib_obj::nmeGetCurrent()->nmeGetStage();		HX_STACK_VAR(stage,"stage");
		HX_STACK_LINE(40)
		stage->nmeSetScaleMode(::neash::display::StageScaleMode_obj::NO_SCALE_dyn());
		HX_STACK_LINE(41)
		stage->nmeSetAlign(::neash::display::StageAlign_obj::TOP_LEFT_dyn());
		HX_STACK_LINE(43)
		::nme::Lib_obj::nmeGetCurrent()->addChild(::com::twinnova::infinitystacker::Main_obj::__new());
		HX_STACK_LINE(45)
		::com::twinnova::infinitystacker::Main_obj::fillGrid();
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Main_obj,main,(void))

Void Main_obj::fillGrid( ){
{
		HX_STACK_PUSH("Main::fillGrid","com/twinnova/infinitystacker/Main.hx",49);
		HX_STACK_LINE(50)
		int numRows = ::Math_obj::floor((Float(::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->nmeGetHeight()) / Float(::com::twinnova::infinitystacker::Main_obj::SQUARE_WIDTH)));		HX_STACK_VAR(numRows,"numRows");
		HX_STACK_LINE(52)
		{
			HX_STACK_LINE(52)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(52)
			while(((_g < numRows))){
				HX_STACK_LINE(52)
				int rowNumber = (_g)++;		HX_STACK_VAR(rowNumber,"rowNumber");
				HX_STACK_LINE(54)
				::com::twinnova::infinitystacker::Main_obj::addRow(rowNumber);
			}
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Main_obj,fillGrid,(void))

Void Main_obj::addRow( int rowNumber){
{
		HX_STACK_PUSH("Main::addRow","com/twinnova/infinitystacker/Main.hx",59);
		HX_STACK_ARG(rowNumber,"rowNumber");
		HX_STACK_LINE(60)
		int numColumns = ::Math_obj::floor((Float(::nme::Lib_obj::nmeGetCurrent()->nmeGetStage()->nmeGetWidth()) / Float(::com::twinnova::infinitystacker::Main_obj::SQUARE_WIDTH)));		HX_STACK_VAR(numColumns,"numColumns");
		HX_STACK_LINE(62)
		{
			HX_STACK_LINE(63)
			int _g = (int)0;		HX_STACK_VAR(_g,"_g");
			HX_STACK_LINE(63)
			while(((_g < numColumns))){
				HX_STACK_LINE(63)
				int columnNumber = (_g)++;		HX_STACK_VAR(columnNumber,"columnNumber");
				HX_STACK_LINE(64)
				::com::twinnova::infinitystacker::Main_obj::addSquare(rowNumber,columnNumber);
			}
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Main_obj,addRow,(void))

Void Main_obj::addSquare( int rowNumber,int columnNumber){
{
		HX_STACK_PUSH("Main::addSquare","com/twinnova/infinitystacker/Main.hx",69);
		HX_STACK_ARG(rowNumber,"rowNumber");
		HX_STACK_ARG(columnNumber,"columnNumber");
		HX_STACK_LINE(70)
		::neash::display::Sprite square = ::neash::display::Sprite_obj::__new();		HX_STACK_VAR(square,"square");
		HX_STACK_LINE(71)
		square->nmeGetGraphics()->lineStyle((int)1,(int)65280,(int)1,null(),null(),null(),null(),null());
		HX_STACK_LINE(72)
		square->nmeGetGraphics()->beginFill((int)16711680,null());
		HX_STACK_LINE(73)
		square->nmeGetGraphics()->drawRect(((int)0 * ::com::twinnova::infinitystacker::Main_obj::SQUARE_WIDTH),((int)0 * ::com::twinnova::infinitystacker::Main_obj::SQUARE_WIDTH),::com::twinnova::infinitystacker::Main_obj::SQUARE_WIDTH,::com::twinnova::infinitystacker::Main_obj::SQUARE_WIDTH);
		HX_STACK_LINE(77)
		square->nmeSetAlpha(0.8);
		HX_STACK_LINE(79)
		::nme::Lib_obj::nmeGetCurrent()->addChild(square);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Main_obj,addSquare,(void))


Main_obj::Main_obj()
{
}

void Main_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(Main);
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void Main_obj::__Visit(HX_VISIT_PARAMS)
{
	super::__Visit(HX_VISIT_ARG);
}

Dynamic Main_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"main") ) { return main_dyn(); }
		if (HX_FIELD_EQ(inName,"init") ) { return init_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"addRow") ) { return addRow_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"fillGrid") ) { return fillGrid_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"addSquare") ) { return addSquare_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"SQUARE_WIDTH") ) { return SQUARE_WIDTH; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic Main_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 12:
		if (HX_FIELD_EQ(inName,"SQUARE_WIDTH") ) { SQUARE_WIDTH=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void Main_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("SQUARE_WIDTH"),
	HX_CSTRING("main"),
	HX_CSTRING("fillGrid"),
	HX_CSTRING("addRow"),
	HX_CSTRING("addSquare"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("init"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Main_obj::__mClass,"__mClass");
	HX_MARK_MEMBER_NAME(Main_obj::SQUARE_WIDTH,"SQUARE_WIDTH");
};

static void sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Main_obj::__mClass,"__mClass");
	HX_VISIT_MEMBER_NAME(Main_obj::SQUARE_WIDTH,"SQUARE_WIDTH");
};

Class Main_obj::__mClass;

void Main_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("com.twinnova.infinitystacker.Main"), hx::TCanCast< Main_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics, sVisitStatics);
}

void Main_obj::__boot()
{
	SQUARE_WIDTH= (int)50;
}

} // end namespace com
} // end namespace twinnova
} // end namespace infinitystacker
