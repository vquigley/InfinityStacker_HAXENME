#ifndef INCLUDED_com_twinnova_infinitystacker_Main
#define INCLUDED_com_twinnova_infinitystacker_Main

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <neash/display/Sprite.h>
HX_DECLARE_CLASS3(com,twinnova,infinitystacker,Main)
HX_DECLARE_CLASS2(neash,display,DisplayObject)
HX_DECLARE_CLASS2(neash,display,DisplayObjectContainer)
HX_DECLARE_CLASS2(neash,display,IBitmapDrawable)
HX_DECLARE_CLASS2(neash,display,InteractiveObject)
HX_DECLARE_CLASS2(neash,display,Sprite)
HX_DECLARE_CLASS2(neash,events,EventDispatcher)
HX_DECLARE_CLASS2(neash,events,IEventDispatcher)
namespace com{
namespace twinnova{
namespace infinitystacker{


class Main_obj : public ::neash::display::Sprite_obj{
	public:
		typedef ::neash::display::Sprite_obj super;
		typedef Main_obj OBJ_;
		Main_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< Main_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~Main_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("Main"); }

		virtual Void init( Dynamic e);
		Dynamic init_dyn();

		static int SQUARE_WIDTH; /* REM */ 
		static Void main( );
		static Dynamic main_dyn();

		static Void fillGrid( );
		static Dynamic fillGrid_dyn();

		static Void addRow( int rowNumber);
		static Dynamic addRow_dyn();

		static Void addSquare( int rowNumber,int columnNumber);
		static Dynamic addSquare_dyn();

};

} // end namespace com
} // end namespace twinnova
} // end namespace infinitystacker

#endif /* INCLUDED_com_twinnova_infinitystacker_Main */ 
