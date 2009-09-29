#ifndef bool
#include <iostream.h>
#endif
extern "C" {
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

}
#ifdef bool
#undef bool
#include <iostream.h>
#endif

//#TODO: prefere Perl's memory allocation function than malloc/free
//~ #define PB100
//~ #define PB105
//~ #define PB115
//~ #define PB120

#ifdef PB105
#define PBVM_DLL "pbvm100.dll"
/*#include "C:\\Program Files\\Sybase\\PowerBuilder 10.0\\SDK\\PBNI\\include\\pbext.h"
#include "C:\\Program Files\\Sybase\\PowerBuilder 10.0\\SDK\\PBNI\\include\\pbni.h"
#include "C:\\Program Files\\Sybase\\PowerBuilder 10.0\\SDK\\PBNI\\include\\PBCTXIF.h"*/
#endif

#ifdef PB105
#define PBVM_DLL "pbvm105.dll"
/*#include "C:\\Program Files\\Sybase\\PowerBuilder 10.5\\SDK\\PBNI\\include\\pbext.h"
#include "C:\\Program Files\\Sybase\\PowerBuilder 10.5\\SDK\\PBNI\\include\\pbni.h"
#include "C:\\Program Files\\Sybase\\PowerBuilder 10.5\\SDK\\PBNI\\include\\PBCTXIF.h"*/
#endif

#ifdef PB115
#define PBVM_DLL "pbvm115.dll"
/*#include "C:\\Program Files\\Sybase\\PowerBuilder 11.5\\SDK\\PBNI\\include\\pbext.h"
#include "C:\\Program Files\\Sybase\\PowerBuilder 11.5\\SDK\\PBNI\\include\\pbni.h"
#include "C:\\Program Files\\Sybase\\PowerBuilder 11.5\\SDK\\PBNI\\include\\PBCTXIF.h"*/
#endif

#ifdef PB120
#define PBVM_DLL "pbvm120.dll"
/*#include "C:\\Program Files\\Sybase\\PowerBuilder 12.0\\SDK\\PBNI\\include\\pbext.h"
#include "C:\\Program Files\\Sybase\\PowerBuilder 12.0\\SDK\\PBNI\\include\\pbni.h"
#include "C:\\Program Files\\Sybase\\PowerBuilder 12.0\\SDK\\PBNI\\include\\PBCTXIF.h"*/
#endif

//This files are copied from your installation path by Makefile.PL
#include "sybase/include/pbext.h"
#include "sybase/include/pbni.h"
#include "sybase/include/PBCTXIF.h"

#include "stdio.h"

#include "ppport.h"
#include "const-c.inc"

// Fixes :
//  1) MATH.H  : patched by adding an #if !defined( H_PERL ) ...  template<class _Ty> ... #end if
//  2) PBNI.H : commented redefinition of TRUE and FALSE constant !

typedef PBXEXPORT PBXRESULT (*P_PB_GetVM)(IPB_VM** vm);
#define PVOID (void*)
//#########################
#define pb_val _value()
class Value{
public:
	//~ Value(){ i_value = NULL; }
	//~ Value( IPB_Value* v ){ i_value = v; }
	Value( void* v ){ i_value = (IPB_Value*)v; }
	~Value(){ i_value = NULL; }
	void* get(){ return i_value; }
	void* GetClass(){ 
		return (pbclass)pb_val->GetClass(); 
	}
	unsigned short GetType(){ 
		return (pbuint)pb_val->GetType(); 
	}
	short IsArray(){ 
		return (short)pb_val->IsArray(); 
	}
	short IsObject(){ 
		return (short)pb_val->IsObject(); 
	}
	short IsEnum(){ 
		return (short)pb_val->IsEnum(); 
	}
	short IsByRef(){ 
		return (short)pb_val->IsByRef(); 
	}
	short IsNull(){ 
		return (short)pb_val->IsNull(); 
	}
	long SetToNull(){ 
		return (long)pb_val->SetToNull(); 
	}
	short GetInt(){ 
		return (pbint)pb_val->GetInt(); 
	}
	unsigned short GetUint(){ 
		return (pbuint)pb_val->GetUint(); 
	}
	short GetBool(){ 
		return (short)pb_val->GetBool(); 
	}
	long GetLong(){ 
		return (pblong)pb_val->GetLong(); 
	}
	unsigned long GetUlong(){ 
		return (pbulong)pb_val->GetUlong(); 
	}
	float GetReal(){ 
		return (pbreal)pb_val->GetReal(); 
	}
	double GetDouble(){ 
		return (pbdouble)pb_val->GetDouble(); 
	}
	void* GetDecimal(){ 
		return (pbdec)pb_val->GetDecimal(); 
	}
	unsigned short GetChar(){ 
		return (pbchar)pb_val->GetChar(); 
	}
	void* GetString(){ 
		return (pbstring)pb_val->GetString(); 
	}
	void* GetObject(){ 
		return (pbobject)pb_val->GetObject(); 
	}
	void* GetArray(){ 
		return (pbarray)pb_val->GetArray(); 
	}
	void* GetTime(){ 
		return (pbtime)pb_val->GetTime(); 
	}
	void* GetDate(){ 
		return (pbdate)pb_val->GetDate(); 
	}
	void* GetDateTime(){ 
		return (pbdatetime)pb_val->GetDateTime(); 
	}
/*//	pblonglong GetLongLong(){ 
//		return (pblonglong)pb_val->GetLongLong(); 
//	}*/
	void* GetBlob(){ 
		return (pbblob)pb_val->GetBlob(); 
	}
	long SetInt(short v){ 
		return (long)pb_val->SetInt(v); 
	}
	long SetUint(unsigned short v){ 
		return (long)pb_val->SetUint(v); 
	}
	long SetBool(short v){ 
		return (long)pb_val->SetBool(v); 
	}
	long SetLong(long v){ 
		return (long)pb_val->SetLong(v); 
	}
	long SetUlong(unsigned long v){ 
		return (long)pb_val->SetUlong(v); 
	}
	long SetReal(float v){ 
		return (long)pb_val->SetReal(v); 
	}
	long SetDouble(double v){ 
		return (long)pb_val->SetDouble(v); 
	}
	long SetDecimal(void* v){ 
		return (long)pb_val->SetDecimal((pbdec)v); 
	}
	long SetChar(unsigned short v){ 
		return (long)pb_val->SetChar(v); 
	}
	long SetPBString(void* v){ 
		return (long)pb_val->SetPBString((pbstring)v); 
	}
	long SetString(char* v){ 
		return (long)pb_val->SetString(v); 
	}
	long SetArray(void* v){ 
		return (long)pb_val->SetArray((pbarray)v); 
	}
	long SetTime(void* v){ 
		return (long)pb_val->SetTime((pbtime)v); 
	}
	long SetDate(void* v){ 
		return (long)pb_val->SetDate((pbdate)v); 
	}
	long SetDateTime(void* v){ 
		return (long)pb_val->SetDateTime((pbdatetime)v); 
	}
/*//	long SetLongLong(pblonglong){ 
//		return (long)pb_val->SetLongLong(pblonglong); 
//	}*/
	long SetBlob(void* v){ 
		return (long)pb_val->SetBlob((pbblob)v); 
	}
	long SetObject(void* v){ 
		return (long)pb_val->SetObject((pbobject)v); 
	}
	short IsReadOnly(){ 
		return (short)pb_val->IsReadOnly(); 
	}
	unsigned char GetByte(){ 
		return (unsigned char)pb_val->GetByte(); 
	}
	long SetByte(void* v){ 
		return (long)pb_val->SetByte((pbbyte)v); 
	}
private:
	IPB_Value* i_value;
	IPB_Value* _value(){
		if(i_value==NULL) 
			croak("No value handle !");
		return i_value;
	}
};


#define pb_arg _argument()
class Arguments{
public:
	Arguments( void* arg){ i_arguments = (IPB_Arguments*)arg; }
	~Arguments(){ i_arguments = NULL; }
    short GetCount(){ return pb_arg->GetCount(); }
    void* GetAt(short i){ return (IPB_Value*)pb_arg->GetAt(i); }
private:
	IPB_Arguments* i_arguments;
	IPB_Arguments* _argument(){
		if(i_arguments==NULL) 
			croak("No arguments handle !");	
		return i_arguments;
	}
};

class CallInfo{
public:
	CallInfo(){}
	~CallInfo(){}
	void* get(){ return &i_callinfo; }
	void* Args(){ return i_callinfo.pArgs; }
	void* returnValue(){ return i_callinfo.returnValue; }
	void* returnClass(){ return i_callinfo.returnClass; }
private:
	PBCallInfo i_callinfo;
};

class ArrayInfo{
public:
	ArrayInfo(void* arrayinfo){ i_arrayinfo = (PBArrayInfo*)arrayinfo; }
	~ArrayInfo(){}
	void* get(){ return i_arrayinfo; }
	short IsBoundedArray(){ return i_arrayinfo->arrayType == PBArrayInfo::BoundedArray; }
	int valueType(){ return i_arrayinfo->valueType; }
	int numDimensions(){ return i_arrayinfo->numDimensions; }
	long ArrayBoundLower(long dimId){ return i_arrayinfo->bounds[dimId].lowerBound; }
	long ArrayBoundUpper(long dimId){ return i_arrayinfo->bounds[dimId].upperBound; }
private:
	PBArrayInfo* i_arrayinfo;
};
#define session _session()
class PBVM {
 public:
	PBVM(){ 
        pbvm = NULL;
        i_session = NULL;
		i_injected = false;
        i_hinst = LoadLibrary(PBVM_DLL); 
        getvm = (P_PB_GetVM)GetProcAddress(i_hinst,"PB_GetVM");
        getvm(&pbvm);
    }
	~PBVM(){
        if(i_session && !i_injected){
            i_session->Release();
        }
        FreeLibrary(i_hinst); 
    }
	
	IPB_Session* _session(){
		if(i_session==NULL) 
			croak("No session !");
		return i_session;
	}
	
	void AttachSession(){
		//Becare By using this method: you absolutely need to be in the same process than the Session Owner
		//This could be done via some DllInjection thecnical...
		//This hack was tested only with PBVM115.DLL( v11.5 build 3127 )
		//seams to be a constant pointer address in the owner process
		DWORD* sessionptr= (DWORD*)0xEF7940;
		sessionptr = (DWORD*)sessionptr[0];
		i_session = (IPB_Session*)((void*)sessionptr);	//vmGetInstance() ???
		i_injected = true;
		
	}		

	int ReleaseSession(){
		if (i_session!=NULL){
			session->Release();		
			i_session = NULL;
		}
		return 0;
	}
	
	unsigned long GetSessionAddr(){
		return (unsigned long)((void*)i_session);
	}
	
	unsigned long getptr(void* ptr){ return (unsigned long)ptr; }
	void* ref(char* ptr){ return ptr; }
	char* unref(void* ptr){ return (char*)ptr; }
	//La liste des librairies doit etre séparé par des ;
	int CreateSession(char* appName, char* libs, int nblib){
		char* copy_libs = (char*)malloc( 1 + strlen( libs ) );
		//Assert( copy_libs );
		strcpy(copy_libs, libs);
		char* cursor = copy_libs;
		long libcount=0;
		while( *cursor ){
			if(*cursor == ';'){
				libcount++;
			}
			cursor++;
		}
		LPCTSTR *list_libs;
		list_libs = (LPCTSTR *)malloc( sizeof(LPCTSTR) * (libcount+1) );
		cursor = copy_libs;
		list_libs[ libcount=0 ] = cursor;
		while( *cursor ){
			if(*cursor == ';'){
				*cursor = 0;	//make last pointer a real C string / null terminated string
				list_libs[ ++libcount ] = cursor + 1;
			}
			cursor++;
		}

		if(list_libs==NULL){
			free(copy_libs);
			croak("Spliting libs: Could not allocate memory !");
		}
		
		if(i_session!=NULL) ReleaseSession();
        if ( pbvm->CreateSession( (LPCTSTR)appName, list_libs, nblib, &i_session) != PBX_OK ){
			free( list_libs );
			free(copy_libs);
            session->Release();
            i_session = NULL;
            return 1;
        }		
		free( list_libs );
		free(copy_libs);
        return 0;
    }
    
	//La liste des librairies doit etre séparé par des ;
	int RunApplication(char* appName, char* libs, int nblib, char* cmdline){
		char* copy_libs = (char*)malloc( 1 + strlen( libs ) );
		//Assert( copy_libs );
		strcpy(copy_libs, libs);
		char* cursor = copy_libs;
		long libcount=0;
		while( *cursor ){
			if(*cursor == ';'){
				libcount++;
			}
			cursor++;
		}
		LPCTSTR *list_libs;
		list_libs = (LPCTSTR *)malloc( sizeof(LPCTSTR) * (libcount+1) );
		cursor = copy_libs;
		list_libs[ libcount=0 ] = cursor;
		while( *cursor ){
			if(*cursor == ';'){
				*cursor = 0;	//make last pointer a real C string / null terminated string
				list_libs[ ++libcount ] = cursor + 1;
			}
			cursor++;
		}

		if(list_libs==NULL){
			free(copy_libs);
			croak("Spliting libs: Could not allocate memory !");
		}
		
		if(i_session!=NULL) ReleaseSession();
        if ( pbvm->RunApplication( (LPCTSTR)appName, list_libs, nblib, cmdline, &i_session) != PBX_OK ){
			free( list_libs );
			free(copy_libs);
            session->Release();
            i_session = NULL;
            return 1;
        }		
		free( list_libs );
		free(copy_libs);
        return 0;
    }
    //Interface to access String
	void* NewString(char* value){ return (void*)session->NewString( value?value:"" ); }
    const char* GetString(void* pb_string){ return session->GetString( (pbstring)pb_string ); }
    long SetString(void* pb_string, char* value){ return session->SetString( (pbstring)pb_string, value ); }
    long GetStringLength(void* pb_string){ return session->GetStringLength( (pbstring)pb_string ); } 
    //Interface to access Binary.
    void* NewBlob(void* bin, long len){ return PVOID session->NewBlob(bin, len); }
    long SetBlob(void* blob, const void* bin, long len){ return session->SetBlob((pbblob)blob,bin,len); }
    long GetBlobLength(void* pbbin){ return session->GetBlobLength((pbblob)pbbin); }
	void* GetBlob(void* pbbin){ return PVOID session->GetBlob((pbblob)pbbin);	}
    //interface to access decimal number
    void* NewDecimal(){ return PVOID session->NewDecimal(); }
    long SetDecimal(void* dec, char* dec_str){ return session->SetDecimal((pbdec)dec,dec_str); }
    void* GetDecimalString(void* dec){ return (char*)session->GetDecimalString((pbdec)dec); }
    void ReleaseDecimalString(void* s){ session->ReleaseDecimalString((const char*)s); }
    //Interface to access Date, Time and DateTime.
    void* NewDate() { return PVOID session->NewDate(); }
    void* NewTime() { return PVOID session->NewTime(); }
    void* NewDateTime() { return PVOID session->NewDateTime(); }
    long SetDate(void* date, short year, short month, short day){
		return session->SetDate((pbdate)date, year, month, day);
	}
    long SetTime(void* time, short hour, short minute, double second){
		return session->SetTime((pbtime) time,  hour,  minute, second);
	}
	long SetDateTime(void* dt, short year, short month, short day, short hour, short minute, double second){
		return session->SetDateTime((pbdatetime) dt, year, month, day,hour, minute, second);
	}
	long CopyDateTime(void* dest, void* src){
		return session->CopyDateTime((pbdatetime)dest, (pbdatetime)src);
	}
    long SplitDate(void* date, SV* year_sv, SV* month_sv, SV* day_sv){
		short year, month, day;
		long res = session->SplitDate((pbdate) date, &year, &month, &day);
		SvIV_set( year_sv, year );
		SvIV_set( month_sv, month );
		SvIV_set( day_sv, day );
		return res;
	}
	long SplitTime(void* time, SV* hour_sv, SV* minute_sv, SV* second_sv ){
		short hour, minute;
		double second;
		long res = session->SplitTime((pbtime) time, &hour, &minute, &second);
		SvIV_set( hour_sv, hour );
		SvIV_set( minute_sv, minute );
		SvNV_set( second_sv, second );
		return res;
	}
	long SplitDateTime(void* dt, SV* year_sv, SV* month_sv, SV* day_sv, SV* hour_sv, SV* minute_sv, SV* second_sv){
		short year, month, day, hour, minute;
		double second;
		long res = session->SplitDateTime((pbdatetime) dt, &year, &month, &day, &hour, &minute, &second);
		SvIV_set( year_sv, year );
		SvIV_set( month_sv, month );
		SvIV_set( day_sv, day );
		SvIV_set( hour_sv, hour );
		SvIV_set( minute_sv, minute );
		SvNV_set( second_sv, second );
		return res;
	}
    void* GetDateString(void* a){ return (char*)session->GetDateString((pbdate)a); }
    void ReleaseDateString(void* a){ session->ReleaseDateString((const char*)a); }
    void* GetTimeString(void* a){ return (char*)session->GetTimeString((pbtime)a); }
    void ReleaseTimeString(void* a){ session->ReleaseTimeString((const char*)a); }
    void* GetDateTimeString(void* a){ return (char*)session->GetDateTimeString((pbdatetime)a); }
    void ReleaseDateTimeString(void* a){ session->ReleaseDateTimeString((const char*)a); }

	void* GetClass(void* obj){ return PVOID session->GetClass((pbobject)obj); }  
	void* GetSystemGroup(){ 
		return (pbgroup)session->GetSystemGroup(); 
	}
	unsigned short GetMethodID(void* cls, char* methodName, int rt, char* signature, short publicOnly = true){ 
		return (pbmethodID)session->GetMethodID((pbclass) cls, methodName, (PBRoutineType) rt, signature, publicOnly); 
	}
	unsigned short FindMatchingFunction(void* cls, char* methodName, int rt, char* readableSignature){ 
		return (pbmethodID)session->FindMatchingFunction((pbclass) cls, methodName, (PBRoutineType) rt, readableSignature); 
	}
	unsigned short GetMethodIDByEventID(void* cls, char* eventID){ 
		return (pbmethodID)session->GetMethodIDByEventID((pbclass) cls, eventID); 
	}
	long InitCallInfo(void* cls, unsigned short mid, void* ci){ 
		return (long)session->InitCallInfo((pbclass) cls, mid, (PBCallInfo *)ci); 
	}	
	void FreeCallInfo(void* ci){ 
		session->FreeCallInfo((PBCallInfo *)ci); 
	}
	void AddLocalRef(void* obj){ 
		session->AddLocalRef((pbobject) obj); 
	}
	void RemoveLocalRef(void* obj){ 
		session->RemoveLocalRef((pbobject) obj); 
	}
	void AddGlobalRef(void* obj){ 
		session->AddGlobalRef((pbobject) obj); 
	}
	void RemoveGlobalRef(void* obj){ 
		session->RemoveGlobalRef((pbobject) obj); 
	}
	void PushLocalFrame(){ 
		session->PushLocalFrame(); 
	}
	void PopLocalFrame(){ 
		session->PopLocalFrame(); 
	}
	// For passing variable arguments.
	long   AddIntArgument(void* ci, short value, short isNull=FALSE){ 
		return (long)session->AddIntArgument((PBCallInfo *)ci, value, isNull); 
	}
	long AddLongArgument(void *ci, long value, short isNull=FALSE){ 
		return (long)session->AddLongArgument((PBCallInfo *)ci, value, isNull); 
	}
	long AddRealArgument(void* ci, float value, short isNull=FALSE){ 
		return (long)session->AddRealArgument((PBCallInfo *)ci, value, isNull); 
	}
	long AddDoubleArgument(void* ci, double value, short isNull=FALSE){ 
		return (long)session->AddDoubleArgument((PBCallInfo *)ci, value, isNull); 
	}
	long AddDecArgument(void* ci, void* value, short isNull=FALSE){ 
		return (long)session->AddDecArgument((PBCallInfo *)ci, (pbdec) value, isNull); 
	}
	long AddPBStringArgument(void* ci, void* value, short isNull=FALSE){ 
		return (long)session->AddPBStringArgument((PBCallInfo *)ci, (pbstring) value, isNull); 
	}
	long AddStringArgument(void* ci, char* value, short isNull=FALSE){ 
		return (long)session->AddStringArgument((PBCallInfo *)ci, value, isNull); 
	}
	long AddBoolArgument(void* ci, short value, short isNull=FALSE){ 
		return (long)session->AddBoolArgument((PBCallInfo *)ci, value, isNull); 
	}
	long AddUintArgument(void* ci, unsigned short value, short isNull=FALSE){ 
		return (long)session->AddUintArgument((PBCallInfo *)ci, value, isNull); 
	}
	long AddUlongArgument(void* ci, unsigned long value, short isNull=FALSE){ 
		return (long)session->AddUlongArgument((PBCallInfo *)ci, value, isNull); 
	}
	long AddBlobArgument(void* ci, void* value, short isNull=FALSE){ 
		return (long)session->AddBlobArgument((PBCallInfo *)ci, (pbblob) value, isNull); 
	}
	long AddDateArgument(void* ci, void* value, short isNull=FALSE){ 
		return (long)session->AddDateArgument((PBCallInfo *)ci, (pbdate) value, isNull); 
	}
	long AddTimeArgument(void* ci, void* value, short isNull=FALSE){ 
		return (long)session->AddTimeArgument((PBCallInfo *)ci, (pbtime) value, isNull); 
	}
	long AddDateTimeArgument(void* ci, void* value, short isNull=FALSE){ 
		return (long)session->AddDateTimeArgument((PBCallInfo *)ci, (pbdatetime) value, isNull); 
	}
	long AddCharArgument(void* ci, unsigned short value, short isNull=FALSE){ 
		return (long)session->AddCharArgument((PBCallInfo *)ci, value, isNull); 
	}
	/*//~ long AddLongLongArgument(void* ci, longlong value, short isNull=FALSE){ 
		//~ return (long)session->AddLongLongArgument((PBCallInfo *)ci, value, isNull); 
	//~ }*/
	long AddObjectArgument(void* ci, void* value, short isNull=FALSE){ 
		return (long)session->AddObjectArgument((PBCallInfo *)ci, (pbobject) value, isNull); 
	}
	long AddArrayArgument(void* ci, void* value, short isNull=FALSE){ 
		return (long)session->AddArrayArgument((PBCallInfo *)ci, (pbarray) value, isNull); 
	}
	long InvokeClassFunction(void* cls, unsigned short mid, void* ci){ 
		return (long)session->InvokeClassFunction((pbclass) cls, mid, (PBCallInfo *)ci); 
	}
	long InvokeObjectFunction(void* obj, unsigned short mid, void* ci){ 
		return (long)session->InvokeObjectFunction((pbobject) obj, mid, (PBCallInfo *)ci); 
	}
	long TriggerEvent(void* obj, unsigned short mid, void* ci){ 
		return (long)session->TriggerEvent((pbobject) obj, mid, (PBCallInfo *)ci); 
	}
	short HasExceptionThrown(){ 
		return (short)session->HasExceptionThrown(); 
	}
	void* GetException(){ 
		return (pbobject)session->GetException(); 
	}
	void ClearException(){ 
		session->ClearException(); 
	}
	void ThrowException(void*  ex){ 
		session->ThrowException((pbobject) ex); 
	}
	void* GetCurrGroup(){ 
		return (pbgroup)session->GetCurrGroup(); 
	}
	void* FindGroup(char* name, int gt){ 
		return (pbgroup)session->FindGroup(name, (pbgroup_type)gt); 
	}
	void* FindClass(void* group, char* name){ 
		return (pbclass)session->FindClass((pbgroup) group, name); 
	}
	void* FindClassByClassID(void* group, short classID){ 
		return (pbclass)session->FindClassByClassID((pbgroup) group, classID); 
	}
	char* GetClassName(void* cls){ 
		return (char*)session->GetClassName((pbclass) cls); 
	}
	void* GetSuperClass(void*  cls){ 
		return (pbclass)session->GetSuperClass((pbclass) cls); 
	}
	void* GetSystemClass(void*  cls){ 
		return (pbclass)session->GetSystemClass((pbclass) cls); 
	}
	short IsAutoInstantiate(void*  pbcls){ 
		return (short)session->IsAutoInstantiate((pbclass) pbcls); 
	}
	void* NewObject(void*  cls){ 
		return (pbobject)session->NewObject((pbclass) cls); 
	}
	unsigned short GetFieldID(void* cls, char* fieldName){ 
		return (pbfieldID)session->GetFieldID((pbclass) cls, fieldName); 
	}
	unsigned short      GetFieldType(void* cl, unsigned short f){ 
		return (unsigned short)session->GetFieldType((pbclass)cl, f); 
	}
	unsigned long     GetNumOfFields(void* cl){ 
		return (unsigned long)session->GetNumOfFields((pbclass)cl); 
	}
	char* GetFieldName(void* cl , unsigned short f){ 
		return (char*)session->GetFieldName((pbclass)cl, f); 
	}
	short IsFieldNull(void* o, unsigned short f){ 
		return (short)session->IsFieldNull((pbobject)o, f); 
	}
	void SetFieldToNull(void* o, unsigned short f){ 
		session->SetFieldToNull((pbobject)o, f); 
	}
	short IsFieldArray(void* cl, unsigned short f){ 
		return (short)session->IsFieldArray((pbclass) cl, f); 
	}
	short IsFieldObject(void* cl, unsigned short f){ 
		return (short)session->IsFieldObject((pbclass) cl, f); 
	}
	long UpdateField(void* obj, unsigned short fid){ 
		return (long)session->UpdateField((pbobject) obj, fid); 
	}
	short GetIntField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		short res = (short)session->GetIntField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res; 
	}
	long GetLongField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		long res = (long)session->GetLongField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	float GetRealField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		float res = (float)session->GetRealField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	double GetDoubleField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		double res = (double)session->GetDoubleField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetDecField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbdec)session->GetDecField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetStringField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbstring)session->GetStringField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	short GetBoolField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		short res = (short)session->GetBoolField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	unsigned short      GetUintField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		unsigned short res = (unsigned short)session->GetUintField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	unsigned long     GetUlongField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		unsigned long res = (unsigned long)session->GetUlongField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetBlobField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbblob)session->GetBlobField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetDateField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbdate)session->GetDateField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetTimeField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbtime)session->GetTimeField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetDateTimeField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbdatetime)session->GetDateTimeField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	unsigned short      GetCharField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		unsigned short res = (unsigned short)session->GetCharField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	/*//~ longlong GetLongLongField(void* obj, unsigned short fid, SV* isNullsv){ 
		//~ short isNull;
		//~ longlong res = (longlong)session->GetLongLongField((pbobject) obj,  fid, isNull); 
		//~ sv_setpviv( isNullsv, isNull );
		//~ return res;  
	//~ }*/
	void* GetObjectField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbobject)session->GetObjectField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetArrayField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbarray)session->GetArrayField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	long SetIntField(void* obj, unsigned short fid, short value){ 
		return (long)session->SetIntField((pbobject) obj,  fid, value); 
	}
	long SetLongField(void* obj, unsigned short fid, long value){ 
		return (long)session->SetLongField((pbobject) obj,  fid, value); 
	}
	long SetRealField(void* obj, unsigned short fid, float value){ 
		return (long)session->SetRealField((pbobject) obj,  fid, value); 
	}
	long SetDoubleField(void* obj, unsigned short fid, double value){ 
		return (long)session->SetDoubleField((pbobject) obj,  fid, value); 
	}
	long SetDecField(void* obj, unsigned short fid, void* value){ 
		return (long)session->SetDecField((pbobject) obj,  fid, (pbdec) value); 
	}
	long SetPBStringField(void* obj, unsigned short fid, void* value){ 
		return (long)session->SetPBStringField((pbobject) obj,  fid, (pbstring)value); 
	}
	long SetStringField(void* obj, unsigned short fid, char* value){ 
		return (long)session->SetStringField((pbobject) obj,  fid, value); 
	}
	long SetBoolField(void* obj, unsigned short fid, short value){ 
		return (long)session->SetBoolField((pbobject) obj,  fid,  value); 
	}
	long SetUintField(void* obj, unsigned short fid, unsigned short value){ 
		return (long)session->SetUintField((pbobject) obj,  fid,  value); 
	}
	long SetUlongField(void* obj, unsigned short fid, unsigned long value){ 
		return (long)session->SetUlongField((pbobject) obj,  fid, value); 
	}
	long SetBlobField(void* obj, unsigned short fid, void* value){ 
		return (long)session->SetBlobField((pbobject) obj,  fid, (pbblob)value); 
	}
	long SetDateField(void* obj, unsigned short fid, void* value){ 
		return (long)session->SetDateField((pbobject) obj,  fid, (pbdate)value); 
	}
	long SetTimeField(void* obj, unsigned short fid, void* value){ 
		return (long)session->SetTimeField((pbobject) obj,  fid, (pbtime)value); 
	}
	long SetDateTimeField(void* obj, unsigned short fid, void* value){ 
		return (long)session->SetDateTimeField((pbobject) obj,  fid, (pbdatetime)value); 
	}
	long SetCharField(void* obj, unsigned short fid, unsigned short value){ 
		return (long)session->SetCharField((pbobject) obj,  fid, value); 
	}
	/*//~ long SetLongLongField(void* obj, unsigned short fid, longlong value){ 
		//~ return (long)session->SetLongLongField((pbobject) obj,  fid, longlong value); 
	//~ }*/
	long SetObjectField(void* obj, unsigned short fid, void* value){ 
		return (long)session->SetObjectField((pbobject) obj,  fid, (pbobject) value); 
	}
	long SetArrayField(void* obj, unsigned short fid, void*  value){ 
		return (long)session->SetArrayField((pbobject) obj,  fid, (pbarray) value); 
	}
	unsigned short GetSharedVarID(void* group, char* fieldName){ 
		return (unsigned short)session->GetSharedVarID((pbgroup) group, fieldName); 
	}
	unsigned short      GetSharedVarType(void* g, unsigned short f){ 
		return (unsigned short)session->GetSharedVarType((pbgroup)g,  f); 
	}
	short IsSharedVarNull(void* g, unsigned short f){ 
		return (short)session->IsSharedVarNull((pbgroup)g,  f); 
	}
	void SetSharedVarToNull(void* g, unsigned short f){ 
		session->SetSharedVarToNull((pbgroup)g,  f); 
	}
	short IsSharedVarArray(void* g, unsigned short f){ 
		return (short)session->IsSharedVarArray((pbgroup)g,  f); 
	}
	short IsSharedVarObject(void* g, unsigned short f){ 
		return (short)session->IsSharedVarObject((pbgroup)g,  f); 
	}
	short GetIntSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		short res = (short)session->GetIntSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	long GetLongSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		long res = (long)session->GetLongSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	float GetRealSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		float res = (float)session->GetRealSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	double GetDoubleSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		double res = (double)session->GetDoubleSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetDecSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbdec)session->GetDecSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetStringSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbstring)session->GetStringSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	short GetBoolSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		short res = (short)session->GetBoolSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	unsigned short      GetUintSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		unsigned short res = (unsigned short)session->GetUintSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	unsigned long     GetUlongSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		unsigned long res = (unsigned long)session->GetUlongSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetBlobSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbblob)session->GetBlobSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetDateSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbdate)session->GetDateSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetTimeSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbtime)session->GetTimeSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetDateTimeSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbdatetime)session->GetDateTimeSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	unsigned short      GetCharSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		unsigned short res = (unsigned short)session->GetCharSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	/*//~ longlong GetLongLongSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		//~ short isNull;
		//~ longlong res = (longlong)session->GetLongLongSharedVar((pbgroup) group,  fid, isNull); 
		//~ sv_setpviv( isNullsv, isNull );
		//~ return res;  
	//~ }*/
	void* GetObjectSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbobject)session->GetObjectSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetArraySharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbarray)session->GetArraySharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	long SetIntSharedVar(void* group, unsigned short fid, short value){ 
		return (long)session->SetIntSharedVar((pbgroup) group,  fid, value); 
	}
	long SetLongSharedVar(void* group, unsigned short fid, long value){ 
		return (long)session->SetLongSharedVar((pbgroup) group,  fid, value); 
	}
	long SetRealSharedVar(void* group, unsigned short fid, float value){ 
		return (long)session->SetRealSharedVar((pbgroup) group,  fid, value); 
	}
	long SetDoubleSharedVar(void* group, unsigned short fid, double value){ 
		return (long)session->SetDoubleSharedVar((pbgroup) group,  fid, value); 
	}
	long SetDecSharedVar(void* group, unsigned short fid, void* value){ 
		return (long)session->SetDecSharedVar((pbgroup) group,  fid, (pbdec) value); 
	}
	long SetPBStringSharedVar(void* group, unsigned short fid, void* value){ 
		return (long)session->SetPBStringSharedVar((pbgroup) group,  fid, (pbstring)value); 
	}
	long SetStringSharedVar(void* group, unsigned short fid, char* value){ 
		return (long)session->SetStringSharedVar((pbgroup) group,  fid, value); 
	}
	long SetBoolSharedVar(void* group, unsigned short fid, short value){ 
		return (long)session->SetBoolSharedVar((pbgroup) group,  fid, value); 
	}
	long SetUintSharedVar(void* group, unsigned short fid, unsigned short value){ 
		return (long)session->SetUintSharedVar((pbgroup) group,  fid, value); 
	}
	long SetUlongSharedVar(void* group, unsigned short fid, unsigned long value){ 
		return (long)session->SetUlongSharedVar((pbgroup) group,  fid, value); 
	}
	long SetBlobSharedVar(void* group, unsigned short fid, void* value){ 
		return (long)session->SetBlobSharedVar((pbgroup) group,  fid, (pbblob)value); 
	}
	long SetDateSharedVar(void* group, unsigned short fid, void* value){ 
		return (long)session->SetDateSharedVar((pbgroup) group,  fid, (pbdate)value); 
	}
	long SetTimeSharedVar(void* group, unsigned short fid, void* value){ 
		return (long)session->SetTimeSharedVar((pbgroup) group,  fid, (pbtime)value); 
	}
	long SetDateTimeSharedVar(void* group, unsigned short fid, void* value){ 
		return (long)session->SetDateTimeSharedVar((pbgroup) group,  fid, (pbdatetime)value); 
	}
	long SetCharSharedVar(void* group, unsigned short fid, unsigned short value){ 
		return (long)session->SetCharSharedVar((pbgroup) group,  fid, value); 
	}
	/*//~ long SetLongLongSharedVar(void* group, unsigned short fid, longlong value){ 
		//~ return (long)session->SetLongLongSharedVar((pbgroup) group,  fid, (longlong) value); 
	//~ }*/
	long SetObjectSharedVar(void* group, unsigned short fid, void* value){ 
		return (long)session->SetObjectSharedVar((pbgroup) group,  fid, (pbobject) value); 
	}
	long SetArraySharedVar(void* group, unsigned short fid, void*  value){ 
		return (long)session->SetArraySharedVar((pbgroup) group,  fid, (pbarray) value); 
	}
	//Interface to Global Variables
	unsigned short GetGlobalVarID(char* varName){ 
		return (pbfieldID)session->GetGlobalVarID( varName); 
	}
	unsigned short      GetGlobalVarType(unsigned short f){ 
		return (unsigned short)session->GetGlobalVarType( f); 
	}
	short IsGlobalVarNull(unsigned short f){ 
		return (short)session->IsGlobalVarNull(f); 
	}
	void SetGlobalVarToNull(unsigned short f){ 
		session->SetGlobalVarToNull( f); 
	}
	short IsGlobalVarArray(unsigned short f){ 
		return (short)session->IsGlobalVarArray( f); 
	}
	short IsGlobalVarObject(unsigned short f){ 
		return (short)session->IsGlobalVarObject( f); 
	}
	short GetIntGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		short res = (short)session->GetIntGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	long GetLongGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		long res = (long)session->GetLongGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	float GetRealGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		float res = (float)session->GetRealGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	double GetDoubleGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		double res = (double)session->GetDoubleGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetDecGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbdec)session->GetDecGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetStringGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbstring)session->GetStringGlobalVar( fid, isNull);
		sv_setpviv( isNullsv, isNull );
		return res; 
	}
	short GetBoolGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		short res = (short)session->GetBoolGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	unsigned short      GetUintGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		unsigned short res = (unsigned short)session->GetUintGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	unsigned long     GetUlongGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		unsigned long res = (unsigned long)session->GetUlongGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetBlobGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbblob)session->GetBlobGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetDateGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbdate)session->GetDateGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetTimeGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbtime)session->GetTimeGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetDateTimeGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbdatetime)session->GetDateTimeGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	char      GetCharGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		char res = (char)session->GetCharGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	/*//~ longlong GetLongLongGlobalVar(unsigned short fid, SV* isNullsv){ 
		//~ short isNull;
		//~ longlong res = (longlong)session->GetLongLongGlobalVar( fid, isNull); 
		//~ sv_setpviv( isNullsv, isNull );
		//~ return res;  
	//~ }*/
	void* GetObjectGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbobject)session->GetObjectGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetArrayGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		void* res = (pbarray)session->GetArrayGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	long SetIntGlobalVar(unsigned short fid, short value){ 
		return (long)session->SetIntGlobalVar( fid,  value); 
	}
	long SetLongGlobalVar(unsigned short fid, long value){ 
		return (long)session->SetLongGlobalVar( fid,  value); 
	}
	long SetRealGlobalVar(unsigned short fid, float value){ 
		return (long)session->SetRealGlobalVar( fid,  value); 
	}
	long SetDoubleGlobalVar(unsigned short fid, double value){ 
		return (long)session->SetDoubleGlobalVar( fid,  value); 
	}
	long SetDecGlobalVar(unsigned short fid, void* value){ 
		return (long)session->SetDecGlobalVar( fid, (pbdec) value); 
	}
	long SetPBStringGlobalVar(unsigned short fid, void* value){ 
		return (long)session->SetPBStringGlobalVar( fid, (pbstring)value); 
	}
	long SetStringGlobalVar(unsigned short fid, char* value){ 
		return (long)session->SetStringGlobalVar( fid, value); 
	}
	long SetBoolGlobalVar(unsigned short fid, short value){ 
		return (long)session->SetBoolGlobalVar( fid, value); 
	}
	long SetUintGlobalVar(unsigned short fid, unsigned short value){ 
		return (long)session->SetUintGlobalVar( fid, value); 
	}
	long SetUlongGlobalVar(unsigned short fid, unsigned long value){ 
		return (long)session->SetUlongGlobalVar( fid, value); 
	}
	long SetBlobGlobalVar(unsigned short fid, void* value){ 
		return (long)session->SetBlobGlobalVar( fid, (pbblob)value); 
	}
	long SetDateGlobalVar(unsigned short fid, void* value){ 
		return (long)session->SetDateGlobalVar( fid, (pbdate)value); 
	}
	long SetTimeGlobalVar(unsigned short fid, void* value){ 
		return (long)session->SetTimeGlobalVar( fid, (pbtime)value); 
	}
	long SetDateTimeGlobalVar(unsigned short fid, void* value){ 
		return (long)session->SetDateTimeGlobalVar( fid, (pbdatetime)value); 
	}
	long SetCharGlobalVar(unsigned short fid, char value){ 
		return (long)session->SetCharGlobalVar( fid, (unsigned short)value); 
	}
	/*//~ long SetLongLongGlobalVar(unsigned short fid, longlong value){ 
		//~ return (long)session->SetLongLongGlobalVar( fid, longlong value); 
	//~ }*/
	long SetObjectGlobalVar(unsigned short fid, void* value){ 
		return (long)session->SetObjectGlobalVar( fid, (pbobject) value); 
	}
	long SetArrayGlobalVar(unsigned short fid, void*  value){ 
		return (long)session->SetArrayGlobalVar( fid, (pbarray) value); 
	}
	short IsNativeObject(void* obj){ 
		return (short)session->IsNativeObject((pbobject) obj); 
	}
	IPBX_UserObject* GetNativeInterface(void* obj){ 
		return (IPBX_UserObject*)session->GetNativeInterface((pbobject) obj); 
	}

    //Interface to access Array
	void* NewBoundedSimpleArray(unsigned short type, AV* boundaries ){ 
		PBArrayInfo::ArrayBound *bounds;
		long dimensions;
		//sv_dump( (SV*)boundaries );
		dimensions =  av_len( boundaries ) +1;
		if(dimensions%2) croak( "usage: NewBoundedSimpleArray( type, [lowerbound, upperbound, ...] )" );
		dimensions = dimensions/2;
		bounds = (PBArrayInfo::ArrayBound *) malloc( sizeof(PBArrayInfo::ArrayBound) * dimensions );
		for(int i=0;i<dimensions; i++){
			SV** value;
			value = av_fetch( boundaries, 2*i, 0);
			bounds[i].lowerBound = SvIV(*value);
			value = av_fetch( boundaries, 2*i+1, 0);
			bounds[i].upperBound = SvIV(*value);
		}
		pbarray a = (pbarray)session->NewBoundedSimpleArray(type, (unsigned short)dimensions, bounds);
		free(bounds);
		return a;
	} //bounded array are fixed size, can be multidimension	

	void* NewUnboundedSimpleArray(unsigned short type){ 
		return (pbarray)session->NewUnboundedSimpleArray(type); 
	} //unbounded array are variable size, can only 1 dimension
	void* NewBoundedObjectArray(void* cl, unsigned short dimensions, void* bounds){ 
		return (pbarray)session->NewBoundedObjectArray((pbclass) cl, dimensions, (PBArrayInfo::ArrayBound*) bounds); 
	} //bounded array are fixed size, can be multidimension
	void* NewUnboundedObjectArray(void* c){ 
		return (pbarray)session->NewUnboundedObjectArray((pbclass)c); 
	} //unbounded array are variable size, can only 1 dimension
	long GetArrayLength(void*  a){ 
		return (long)session->GetArrayLength((pbarray) a); 
	}
	void* GetArrayInfo(void*  a){ 
		return (PBArrayInfo*)session->GetArrayInfo((pbarray) a); 
	}
	long ReleaseArrayInfo(void* a){ 
		return (long)session->ReleaseArrayInfo((PBArrayInfo*) a); 
	} // Release info, if and only if the memory is allocated from pb

	long* __AV2LongPtrPtr( AV* av_array ){
		long* longpp;
		long alength;
		alength = av_len( av_array )+1;
		//~ sv_dump( (SV*) av_array );
		if( !alength ) croak("usage: __AV2LongPtrPtr( [ l, m, n, ...] ) with #@>0 !");
		Newx( longpp, alength, long );
		for(int i=0;i<alength;i++){
			SV** value = av_fetch( av_array, i, 0 );
			longpp[i] = SvIV(*value);
		}
		return longpp;
	}

	short IsArrayItemNull(void*  array, AV* dim_array){
		long * dim = __AV2LongPtrPtr( dim_array );
		short retval = (short)session->IsArrayItemNull((pbarray) array, dim); 
		Safefree( dim );
		return retval;
	}

	void SetArrayItemToNull(void*  array, AV* dim_array){
		long * dim = __AV2LongPtrPtr( dim_array );
		session->SetArrayItemToNull((pbarray) array, dim ); 
		Safefree( dim );
	}

	unsigned short GetArrayItemType(void*  array, AV* dim_array){
		long * dim = __AV2LongPtrPtr( dim_array );
		unsigned short retval = session->GetArrayItemType((pbarray) array, dim ); 
		Safefree( dim );
		return retval;
	}
	
	short GetIntArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		short res = (short)session->GetIntArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}

	long GetLongArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		long res = (long)session->GetLongArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}
	float GetRealArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		float res = (float)session->GetRealArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}
	double GetDoubleArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		double res = (double)session->GetDoubleArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}
	void* GetDecArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		void* res = (pbdec)session->GetDecArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}

	void* GetStringArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		void* res = (pbstring)session->GetStringArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}
	short GetBoolArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		short res = (short)session->GetBoolArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}
	unsigned short GetUintArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		unsigned short res = (unsigned short)session->GetUintArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}
	unsigned long GetUlongArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		unsigned long res = (unsigned long)session->GetUlongArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}
	void* GetBlobArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		void* res = (pbblob)session->GetBlobArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}
	void* GetDateArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		void* res = (pbdate)session->GetDateArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}
	void* GetTimeArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		void* res = (pbtime)session->GetTimeArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}
	void* GetDateTimeArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		void* res = (pbdatetime)session->GetDateTimeArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}
	unsigned short GetCharArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		unsigned short res = (unsigned short)session->GetCharArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;
	}
	/*//~ longlong GetLongLongArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		//~ short isNull;
		//~ long * dim = __AV2LongPtrPtr( dim_array );
		//~ longlong res = (longlong)session->GetLongLongArrayItem((pbarray) array, dim, isNull); 
		//~ sv_setpviv( isNullsv, isNull );
		//~ Safefree( dim );
		//~ return res;  
	//~ }*/
	void* GetObjectArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		void* res = (pbobject)session->GetObjectArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}

	long SetIntArrayItem(void*  array, AV* dim_array, short v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetIntArrayItem((pbarray) array, dim, v); 
		Safefree( dim );
		return retval;
	}
	long SetLongArrayItem(void*  array, AV* dim_array, long v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetLongArrayItem((pbarray) array, dim, v);
		Safefree( dim );
		return retval;
	}
	long SetRealArrayItem(void*  array, AV* dim_array, float v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetRealArrayItem((pbarray) array, dim, v); 
		Safefree( dim );
		return retval;
	}
	long SetDoubleArrayItem(void*  array, AV* dim_array, double v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetDoubleArrayItem((pbarray) array, dim, v); 
		Safefree( dim );
		return retval;
	}
	long SetDecArrayItem(void*  array, AV* dim_array, void* v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetDecArrayItem((pbarray) array, dim, (pbdec) v); 
		Safefree( dim );
		return retval;
	}
	long SetPBStringArrayItem(void*  array, AV* dim_array, void* v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetPBStringArrayItem((pbarray) array, dim, (pbstring)v); 
		Safefree( dim );
		return retval;
	}
	long SetStringArrayItem(void*  array, AV* dim_array, char* s){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetStringArrayItem((pbarray) array, dim, s); 
		Safefree( dim );
		return retval;
	}
	long SetBoolArrayItem(void*  array, AV* dim_array, short v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetBoolArrayItem((pbarray) array, dim, v); 
		Safefree( dim );
		return retval;
	}
	long SetUintArrayItem(void*  array, AV* dim_array, unsigned short v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetUintArrayItem((pbarray) array, dim, v); 
		Safefree( dim );
		return retval;
	}
	long SetUlongArrayItem(void*  array, AV* dim_array, unsigned long v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetUlongArrayItem((pbarray) array, dim, v); 
		Safefree( dim );
		return retval;
	}
	long SetBlobArrayItem(void*  array, AV* dim_array, void* v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetBlobArrayItem((pbarray) array, dim, (pbblob)v); 
		Safefree( dim );
		return retval;
	}
	long SetDateArrayItem(void*  array, AV* dim_array, void* v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetDateArrayItem((pbarray) array, dim, (pbdate)v); 
		Safefree( dim );
		return retval;
	}
	long SetTimeArrayItem(void*  array, AV* dim_array, void* v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetTimeArrayItem((pbarray) array, dim, (pbtime)v); 
		Safefree( dim );
		return retval;
	}
	long SetDateTimeArrayItem(void*  array, AV* dim_array, void* v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetDateTimeArrayItem((pbarray) array, dim, (pbdatetime)v); 
		Safefree( dim );
		return retval;
	}
	long SetCharArrayItem(void*  array, AV* dim_array, unsigned short v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetCharArrayItem((pbarray) array, dim, v); 
		Safefree( dim );
		return retval;
	}
	/*//~ long SetLongLongArrayItem(void*  array, AV* dim_array, longlong){ 
		//~ long * dim = __AV2LongPtrPtr( dim_array );
		//~ long retval = (long)session->SetLongLongArrayItem((pbarray) array, dim, longlong); 
		//~ Safefree( dim );
		//~ return retval;
	//~ }*/
	long SetObjectArrayItem(void*  array, AV* dim_array, void* v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetObjectArrayItem((pbarray) array, dim, (pbobject) v); 
		Safefree( dim );
		return retval;
	}
//-------------------------------------------------------------------------------------------------------
	void* NewProxyObject(void* cls){ 
		return (pbproxyObject)session->NewProxyObject((pbclass) cls); 
	}
	long SetMarshaler(void* obj, void* marshaler){ 
		return (long)session->SetMarshaler((pbproxyObject) obj, (IPBX_Marshaler*) marshaler); 
	}
	void* GetMarshaler(void* obj){ 
		return (IPBX_Marshaler*)session->GetMarshaler((pbproxyObject) obj); 
	}
	void* AcquireValue(void* value){ 
		return (IPB_Value*)session->AcquireValue((IPB_Value*) value); 
	}

	void* AcquireArrayItemValue(void*  arr, AV* dim_array){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		IPB_Value* retval = session->AcquireArrayItemValue((pbarray) arr, dim); 
		Safefree( dim );
		return retval;
	}

	void SetValue(void* dest, void* src){ 
		session->SetValue((IPB_Value*) dest, (IPB_Value*) src); 
	}

	void SetArrayItemValue(void*  arr, AV* dim_array, void* src){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		session->SetArrayItemValue((pbarray) arr, dim, (IPB_Value*) src); 
		Safefree( dim );
	}

	void ReleaseValue(void* value){ 
		session->ReleaseValue((IPB_Value*) value); 
	}
	void SetProp(char* name, void* data){ 
		session->SetProp(name, data); 
	}
	void* GetProp(char* name){ 
		return (void*)session->GetProp(name); 
	}
	void RemoveProp(char* name){ 
		session->RemoveProp(name); 
	}
	short ProcessPBMessage(){ 
		return (short)session->ProcessPBMessage(); 
	}
	long GetEnumItemValue(char* enumName, char* enumItemName){ 
		return (long)session->GetEnumItemValue(enumName, enumItemName); 
	}
	char* GetEnumItemName(char* enumName, long enumItemValue){ 
		return (char*)session->GetEnumItemName(enumName, enumItemValue); 
	}
	void* GetPBAnyField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		IPB_Value* res = (IPB_Value*)session->GetPBAnyField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetPBAnySharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		IPB_Value* res = (IPB_Value*)session->GetPBAnySharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}
	void* GetPBAnyGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		IPB_Value* res = (IPB_Value*)session->GetPBAnyGlobalVar( fid, isNull);
		sv_setpviv( isNullsv, isNull );
		return res;
	}
	void* GetPBAnyArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		IPB_Value* res = (IPB_Value*)session->GetPBAnyArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}
	void* CreateResultSet(void* rs){ 
		return (pbobject)session->CreateResultSet((IPB_ResultSetAccessor*) rs); 
	}
	IPB_ResultSetAccessor* GetResultSetAccessor(void* rs){ 
		return (IPB_ResultSetAccessor*)session->GetResultSetAccessor((pbobject) rs); 
	}
	void ReleaseResultSetAccessor(void* rs){ 
		session->ReleaseResultSetAccessor((IPB_ResultSetAccessor*) rs); 
	}
	short RestartRequested(){ 
		return (short)session->RestartRequested(); 
	}
	short HasPBVisualObject(){ 
		return (short)session->HasPBVisualObject(); 
	}
	void SetDebugTrace(char* traceFile){ 
		session->SetDebugTrace(traceFile); 
	}
	
//**********************************************************
//	Begin of the new type BYTE
//**********************************************************
	long AddByteArgument(void *ci, unsigned char value, short isNull=FALSE){ 
		return (long)session->AddByteArgument((PBCallInfo *)ci, value, isNull); 
	}	
	unsigned short	GetByteField(void* obj, unsigned short fid, SV* isNullsv){ 
		short isNull;
		unsigned short res = (unsigned short)session->GetByteField((pbobject) obj,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}	
	long SetByteField(void* obj, unsigned short fid, unsigned char value){ 
		return (long)session->SetByteField((pbobject) obj,  fid, value); 
	}	
	unsigned short      	GetByteSharedVar(void* group, unsigned short fid, SV* isNullsv){ 
		short isNull;
		unsigned short res = (unsigned short)session->GetByteSharedVar((pbgroup) group,  fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}		
	long SetByteSharedVar(void* group, unsigned short fid, unsigned char value){ 
		return (long)session->SetByteSharedVar((pbgroup) group,  fid, value); 
	}	
	unsigned short GetByteGlobalVar(unsigned short fid, SV* isNullsv){ 
		short isNull;
		unsigned short res = (unsigned short)session->GetByteGlobalVar( fid, isNull); 
		sv_setpviv( isNullsv, isNull );
		return res;  
	}		
	long SetByteGlobalVar(unsigned short fid, unsigned char value){ 
		return (long)session->SetByteGlobalVar( fid, value); 
	}		
	unsigned short GetByteArrayItem(void*  array, AV* dim_array, SV* isNullsv){ 
		short isNull;
		long * dim = __AV2LongPtrPtr( dim_array );
		unsigned short res = (unsigned short)session->GetByteArrayItem((pbarray) array, dim, isNull); 
		sv_setpviv( isNullsv, isNull );
		Safefree( dim );
		return res;  
	}
	
	long SetByteArrayItem(void*  array, AV* dim_array, unsigned short v){ 
		long * dim = __AV2LongPtrPtr( dim_array );
		long retval = (long)session->SetByteArrayItem((pbarray) array, dim, (unsigned char)v); 
		Safefree( dim );
		return retval;
	}		
//**********************************************************
//	End of the new type BYTE
//**********************************************************

private:
	HINSTANCE i_hinst;
	P_PB_GetVM getvm;
	IPB_VM* pbvm;
	IPB_Session* i_session;
	bool i_injected;
};


MODULE = Powerbuilder::PBVM     	PACKAGE = Powerbuilder::Value

PROTOTYPES: DISABLE

Value *
Value::new(v)
	void *	v
    
void
Value::DESTROY()
    
void *
Value::get()
    
void *
Value::GetClass()
    
unsigned short
Value::GetType()
    
short
Value::IsArray()
    
short
Value::IsObject()
    
short
Value::IsEnum()
    
short
Value::IsByRef()
    
short
Value::IsNull()
    
long
Value::SetToNull()
    
short
Value::GetInt()
    
unsigned short
Value::GetUint()
    
short
Value::GetBool()
    
long
Value::GetLong()
    
unsigned long
Value::GetUlong()
    
float
Value::GetReal()
    
double
Value::GetDouble()
    
void *
Value::GetDecimal()
    
unsigned short
Value::GetChar()
    
void *
Value::GetString()
    
void *
Value::GetObject()
    
void *
Value::GetArray()
    
void *
Value::GetTime()
    
void *
Value::GetDate()
    
void *
Value::GetDateTime()
    
void *
Value::GetBlob()
    
long
Value::SetInt(v)
	short	v
    
long
Value::SetUint(v)
	unsigned short	v
    
long
Value::SetBool(v)
	short	v
    
long
Value::SetLong(v)
	long	v
    
long
Value::SetUlong(v)
	unsigned long	v
    
long
Value::SetReal(v)
	float	v
    
long
Value::SetDouble(v)
	double	v
    
long
Value::SetDecimal(v)
	void *	v
    
long
Value::SetChar(v)
	unsigned short	v
    
long
Value::SetPBString(v)
	void *	v
    
long
Value::SetString(v)
	char *	v
    
long
Value::SetArray(v)
	void *	v
    
long
Value::SetTime(v)
	void *	v
    
long
Value::SetDate(v)
	void *	v
    
long
Value::SetDateTime(v)
	void *	v
    
long
Value::SetBlob(v)
	void *	v
    
long
Value::SetObject(v)
	void *	v
    
short
Value::IsReadOnly()
    
unsigned char
Value::GetByte()
    
long
Value::SetByte(v)
	void *	v
    

MODULE = Powerbuilder::PBVM     	PACKAGE = Powerbuilder::Arguments

PROTOTYPES: DISABLE

Arguments *
Arguments::new(arg)
	void *	arg
    
void
Arguments::DESTROY()
    
short
Arguments::GetCount()
    
void *
Arguments::GetAt(i)
	short	i
    

MODULE = Powerbuilder::PBVM     	PACKAGE = Powerbuilder::CallInfo

PROTOTYPES: DISABLE

CallInfo *
CallInfo::new()
    
void
CallInfo::DESTROY()
    
void *
CallInfo::get()
    
void *
CallInfo::Args()
    
void *
CallInfo::returnValue()
    
void *
CallInfo::returnClass()
    

MODULE = Powerbuilder::PBVM     	PACKAGE = Powerbuilder::ArrayInfo

PROTOTYPES: DISABLE

ArrayInfo *
ArrayInfo::new(arrayinfo)
	void *	arrayinfo
    
void
ArrayInfo::DESTROY()
    
void *
ArrayInfo::get()
    
short
ArrayInfo::IsBoundedArray()
    
int
ArrayInfo::valueType()
    
int
ArrayInfo::numDimensions()
    
long
ArrayInfo::ArrayBoundLower(dimId)
	long	dimId
    
long
ArrayInfo::ArrayBoundUpper(dimId)
	long	dimId
    

MODULE = Powerbuilder::PBVM     	PACKAGE = Powerbuilder::PBVM

PROTOTYPES: DISABLE


INCLUDE: const-xs.inc
PBVM *
PBVM::new()
    
void
PBVM::DESTROY()
    
void
PBVM::AttachSession()
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->AttachSession();
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

int
PBVM::ReleaseSession()
    
unsigned long
PBVM::GetSessionAddr()
    
unsigned long
PBVM::getptr(ptr)
	void *	ptr
    
void *
PBVM::ref(ptr)
	char *	ptr
    
char *
PBVM::unref(ptr)
	void *	ptr
    
int
PBVM::CreateSession(appName, libs, nblib)
	char *	appName
	char *	libs
	int	nblib
    
int
PBVM::RunApplication(appName, libs, nblib, cmdline)
	char *	appName
	char *	libs
	int	nblib
	char *	cmdline
    
void *
PBVM::NewString(value)
	char *	value
    
char *
PBVM::GetString(pb_string)
	void *	pb_string
    CODE:
	RETVAL = const_cast<char *>(THIS->GetString(pb_string));
    OUTPUT:
RETVAL

long
PBVM::SetString(pb_string, value)
	void *	pb_string
	char *	value
    
long
PBVM::GetStringLength(pb_string)
	void *	pb_string
    
void *
PBVM::NewBlob(bin, len)
	void *	bin
	long	len
    
long
PBVM::SetBlob(blob, bin, len)
	void *	blob
	void *	bin
	long	len
    CODE:
	RETVAL = THIS->SetBlob(blob,bin,len);
    OUTPUT:
RETVAL

long
PBVM::GetBlobLength(pbbin)
	void *	pbbin
    
void *
PBVM::GetBlob(pbbin)
	void *	pbbin
    
void *
PBVM::NewDecimal()
    
long
PBVM::SetDecimal(dec, dec_str)
	void *	dec
	char *	dec_str
    
void *
PBVM::GetDecimalString(dec)
	void *	dec
    
void
PBVM::ReleaseDecimalString(s)
	void *	s
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->ReleaseDecimalString(s);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void *
PBVM::NewDate()
    
void *
PBVM::NewTime()
    
void *
PBVM::NewDateTime()
    
long
PBVM::SetDate(date, year, month, day)
	void *	date
	short	year
	short	month
	short	day
    
long
PBVM::SetTime(time, hour, minute, second)
	void *	time
	short	hour
	short	minute
	double	second
    
long
PBVM::SetDateTime(dt, year, month, day, hour, minute, second)
	void *	dt
	short	year
	short	month
	short	day
	short	hour
	short	minute
	double	second
    
long
PBVM::CopyDateTime(dest, src)
	void *	dest
	void *	src
    
long
PBVM::SplitDate(date, year_sv, month_sv, day_sv)
	void *	date
	SV *	year_sv
	SV *	month_sv
	SV *	day_sv
    
long
PBVM::SplitTime(time, hour_sv, minute_sv, second_sv)
	void *	time
	SV *	hour_sv
	SV *	minute_sv
	SV *	second_sv
    
long
PBVM::SplitDateTime(dt, year_sv, month_sv, day_sv, hour_sv, minute_sv, second_sv)
	void *	dt
	SV *	year_sv
	SV *	month_sv
	SV *	day_sv
	SV *	hour_sv
	SV *	minute_sv
	SV *	second_sv
    
void *
PBVM::GetDateString(a)
	void *	a
    
void
PBVM::ReleaseDateString(a)
	void *	a
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->ReleaseDateString(a);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void *
PBVM::GetTimeString(a)
	void *	a
    
void
PBVM::ReleaseTimeString(a)
	void *	a
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->ReleaseTimeString(a);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void *
PBVM::GetDateTimeString(a)
	void *	a
    
void
PBVM::ReleaseDateTimeString(a)
	void *	a
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->ReleaseDateTimeString(a);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void *
PBVM::GetClass(obj)
	void *	obj
    
void *
PBVM::GetSystemGroup()
    
unsigned short
PBVM::GetMethodID(cls, methodName, rt, signature, ...)
	void *	cls
	char *	methodName
	int	rt
	char *	signature
    PREINIT:
	short	publicOnly;
    CODE:
switch(items-1) {
case 5:
	publicOnly = (short)SvIV(ST(4));
	RETVAL = THIS->GetMethodID(cls,methodName,rt,signature,publicOnly);
	break; /* case 5 */
default:
	RETVAL = THIS->GetMethodID(cls,methodName,rt,signature);
} /* switch(items) */ 
    OUTPUT:
RETVAL

unsigned short
PBVM::FindMatchingFunction(cls, methodName, rt, readableSignature)
	void *	cls
	char *	methodName
	int	rt
	char *	readableSignature
    
unsigned short
PBVM::GetMethodIDByEventID(cls, eventID)
	void *	cls
	char *	eventID
    
long
PBVM::InitCallInfo(cls, mid, ci)
	void *	cls
	unsigned short	mid
	void *	ci
    
void
PBVM::FreeCallInfo(ci)
	void *	ci
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->FreeCallInfo(ci);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
PBVM::AddLocalRef(obj)
	void *	obj
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->AddLocalRef(obj);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
PBVM::RemoveLocalRef(obj)
	void *	obj
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->RemoveLocalRef(obj);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
PBVM::AddGlobalRef(obj)
	void *	obj
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->AddGlobalRef(obj);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
PBVM::RemoveGlobalRef(obj)
	void *	obj
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->RemoveGlobalRef(obj);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
PBVM::PushLocalFrame()
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->PushLocalFrame();
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
PBVM::PopLocalFrame()
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->PopLocalFrame();
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

long
PBVM::AddIntArgument(ci, value, ...)
	void *	ci
	short	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddIntArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddIntArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddLongArgument(ci, value, ...)
	void *	ci
	long	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddLongArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddLongArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddRealArgument(ci, value, ...)
	void *	ci
	float	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddRealArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddRealArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddDoubleArgument(ci, value, ...)
	void *	ci
	double	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddDoubleArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddDoubleArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddDecArgument(ci, value, ...)
	void *	ci
	void *	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddDecArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddDecArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddPBStringArgument(ci, value, ...)
	void *	ci
	void *	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddPBStringArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddPBStringArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddStringArgument(ci, value, ...)
	void *	ci
	char *	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddStringArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddStringArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddBoolArgument(ci, value, ...)
	void *	ci
	short	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddBoolArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddBoolArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddUintArgument(ci, value, ...)
	void *	ci
	unsigned short	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddUintArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddUintArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddUlongArgument(ci, value, ...)
	void *	ci
	unsigned long	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddUlongArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddUlongArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddBlobArgument(ci, value, ...)
	void *	ci
	void *	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddBlobArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddBlobArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddDateArgument(ci, value, ...)
	void *	ci
	void *	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddDateArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddDateArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddTimeArgument(ci, value, ...)
	void *	ci
	void *	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddTimeArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddTimeArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddDateTimeArgument(ci, value, ...)
	void *	ci
	void *	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddDateTimeArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddDateTimeArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddCharArgument(ci, value, ...)
	void *	ci
	unsigned short	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddCharArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddCharArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddObjectArgument(ci, value, ...)
	void *	ci
	void *	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddObjectArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddObjectArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::AddArrayArgument(ci, value, ...)
	void *	ci
	void *	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddArrayArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddArrayArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

long
PBVM::InvokeClassFunction(cls, mid, ci)
	void *	cls
	unsigned short	mid
	void *	ci
    
long
PBVM::InvokeObjectFunction(obj, mid, ci)
	void *	obj
	unsigned short	mid
	void *	ci
    
long
PBVM::TriggerEvent(obj, mid, ci)
	void *	obj
	unsigned short	mid
	void *	ci
    
short
PBVM::HasExceptionThrown()
    
void *
PBVM::GetException()
    
void
PBVM::ClearException()
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->ClearException();
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
PBVM::ThrowException(ex)
	void *	ex
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->ThrowException(ex);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void *
PBVM::GetCurrGroup()
    
void *
PBVM::FindGroup(name, gt)
	char *	name
	int	gt
    
void *
PBVM::FindClass(group, name)
	void *	group
	char *	name
    
void *
PBVM::FindClassByClassID(group, classID)
	void *	group
	short	classID
    
char *
PBVM::GetClassName(cls)
	void *	cls
    
void *
PBVM::GetSuperClass(cls)
	void *	cls
    
void *
PBVM::GetSystemClass(cls)
	void *	cls
    
short
PBVM::IsAutoInstantiate(pbcls)
	void *	pbcls
    
void *
PBVM::NewObject(cls)
	void *	cls
    
unsigned short
PBVM::GetFieldID(cls, fieldName)
	void *	cls
	char *	fieldName
    
unsigned short
PBVM::GetFieldType(cl, f)
	void *	cl
	unsigned short	f
    
unsigned long
PBVM::GetNumOfFields(cl)
	void *	cl
    
char *
PBVM::GetFieldName(cl, f)
	void *	cl
	unsigned short	f
    
short
PBVM::IsFieldNull(o, f)
	void *	o
	unsigned short	f
    
void
PBVM::SetFieldToNull(o, f)
	void *	o
	unsigned short	f
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->SetFieldToNull(o,f);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

short
PBVM::IsFieldArray(cl, f)
	void *	cl
	unsigned short	f
    
short
PBVM::IsFieldObject(cl, f)
	void *	cl
	unsigned short	f
    
long
PBVM::UpdateField(obj, fid)
	void *	obj
	unsigned short	fid
    
short
PBVM::GetIntField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
long
PBVM::GetLongField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
float
PBVM::GetRealField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
double
PBVM::GetDoubleField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetDecField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetStringField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
short
PBVM::GetBoolField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
unsigned short
PBVM::GetUintField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
unsigned long
PBVM::GetUlongField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetBlobField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetDateField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetTimeField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetDateTimeField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
unsigned short
PBVM::GetCharField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetObjectField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetArrayField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
long
PBVM::SetIntField(obj, fid, value)
	void *	obj
	unsigned short	fid
	short	value
    
long
PBVM::SetLongField(obj, fid, value)
	void *	obj
	unsigned short	fid
	long	value
    
long
PBVM::SetRealField(obj, fid, value)
	void *	obj
	unsigned short	fid
	float	value
    
long
PBVM::SetDoubleField(obj, fid, value)
	void *	obj
	unsigned short	fid
	double	value
    
long
PBVM::SetDecField(obj, fid, value)
	void *	obj
	unsigned short	fid
	void *	value
    
long
PBVM::SetPBStringField(obj, fid, value)
	void *	obj
	unsigned short	fid
	void *	value
    
long
PBVM::SetStringField(obj, fid, value)
	void *	obj
	unsigned short	fid
	char *	value
    
long
PBVM::SetBoolField(obj, fid, value)
	void *	obj
	unsigned short	fid
	short	value
    
long
PBVM::SetUintField(obj, fid, value)
	void *	obj
	unsigned short	fid
	unsigned short	value
    
long
PBVM::SetUlongField(obj, fid, value)
	void *	obj
	unsigned short	fid
	unsigned long	value
    
long
PBVM::SetBlobField(obj, fid, value)
	void *	obj
	unsigned short	fid
	void *	value
    
long
PBVM::SetDateField(obj, fid, value)
	void *	obj
	unsigned short	fid
	void *	value
    
long
PBVM::SetTimeField(obj, fid, value)
	void *	obj
	unsigned short	fid
	void *	value
    
long
PBVM::SetDateTimeField(obj, fid, value)
	void *	obj
	unsigned short	fid
	void *	value
    
long
PBVM::SetCharField(obj, fid, value)
	void *	obj
	unsigned short	fid
	unsigned short	value
    
long
PBVM::SetObjectField(obj, fid, value)
	void *	obj
	unsigned short	fid
	void *	value
    
long
PBVM::SetArrayField(obj, fid, value)
	void *	obj
	unsigned short	fid
	void *	value
    
unsigned short
PBVM::GetSharedVarID(group, fieldName)
	void *	group
	char *	fieldName
    
unsigned short
PBVM::GetSharedVarType(g, f)
	void *	g
	unsigned short	f
    
short
PBVM::IsSharedVarNull(g, f)
	void *	g
	unsigned short	f
    
void
PBVM::SetSharedVarToNull(g, f)
	void *	g
	unsigned short	f
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->SetSharedVarToNull(g,f);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

short
PBVM::IsSharedVarArray(g, f)
	void *	g
	unsigned short	f
    
short
PBVM::IsSharedVarObject(g, f)
	void *	g
	unsigned short	f
    
short
PBVM::GetIntSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
long
PBVM::GetLongSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
float
PBVM::GetRealSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
double
PBVM::GetDoubleSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetDecSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetStringSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
short
PBVM::GetBoolSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
unsigned short
PBVM::GetUintSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
unsigned long
PBVM::GetUlongSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetBlobSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetDateSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetTimeSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetDateTimeSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
unsigned short
PBVM::GetCharSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetObjectSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetArraySharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
long
PBVM::SetIntSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	short	value
    
long
PBVM::SetLongSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	long	value
    
long
PBVM::SetRealSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	float	value
    
long
PBVM::SetDoubleSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	double	value
    
long
PBVM::SetDecSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	void *	value
    
long
PBVM::SetPBStringSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	void *	value
    
long
PBVM::SetStringSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	char *	value
    
long
PBVM::SetBoolSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	short	value
    
long
PBVM::SetUintSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	unsigned short	value
    
long
PBVM::SetUlongSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	unsigned long	value
    
long
PBVM::SetBlobSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	void *	value
    
long
PBVM::SetDateSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	void *	value
    
long
PBVM::SetTimeSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	void *	value
    
long
PBVM::SetDateTimeSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	void *	value
    
long
PBVM::SetCharSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	unsigned short	value
    
long
PBVM::SetObjectSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	void *	value
    
long
PBVM::SetArraySharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	void *	value
    
unsigned short
PBVM::GetGlobalVarID(varName)
	char *	varName
    
unsigned short
PBVM::GetGlobalVarType(f)
	unsigned short	f
    
short
PBVM::IsGlobalVarNull(f)
	unsigned short	f
    
void
PBVM::SetGlobalVarToNull(f)
	unsigned short	f
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->SetGlobalVarToNull(f);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

short
PBVM::IsGlobalVarArray(f)
	unsigned short	f
    
short
PBVM::IsGlobalVarObject(f)
	unsigned short	f
    
short
PBVM::GetIntGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
long
PBVM::GetLongGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
float
PBVM::GetRealGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
double
PBVM::GetDoubleGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetDecGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetStringGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
short
PBVM::GetBoolGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
unsigned short
PBVM::GetUintGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
unsigned long
PBVM::GetUlongGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetBlobGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetDateGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetTimeGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetDateTimeGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
char
PBVM::GetCharGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetObjectGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetArrayGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
long
PBVM::SetIntGlobalVar(fid, value)
	unsigned short	fid
	short	value
    
long
PBVM::SetLongGlobalVar(fid, value)
	unsigned short	fid
	long	value
    
long
PBVM::SetRealGlobalVar(fid, value)
	unsigned short	fid
	float	value
    
long
PBVM::SetDoubleGlobalVar(fid, value)
	unsigned short	fid
	double	value
    
long
PBVM::SetDecGlobalVar(fid, value)
	unsigned short	fid
	void *	value
    
long
PBVM::SetPBStringGlobalVar(fid, value)
	unsigned short	fid
	void *	value
    
long
PBVM::SetStringGlobalVar(fid, value)
	unsigned short	fid
	char *	value
    
long
PBVM::SetBoolGlobalVar(fid, value)
	unsigned short	fid
	short	value
    
long
PBVM::SetUintGlobalVar(fid, value)
	unsigned short	fid
	unsigned short	value
    
long
PBVM::SetUlongGlobalVar(fid, value)
	unsigned short	fid
	unsigned long	value
    
long
PBVM::SetBlobGlobalVar(fid, value)
	unsigned short	fid
	void *	value
    
long
PBVM::SetDateGlobalVar(fid, value)
	unsigned short	fid
	void *	value
    
long
PBVM::SetTimeGlobalVar(fid, value)
	unsigned short	fid
	void *	value
    
long
PBVM::SetDateTimeGlobalVar(fid, value)
	unsigned short	fid
	void *	value
    
long
PBVM::SetCharGlobalVar(fid, value)
	unsigned short	fid
	char	value
    
long
PBVM::SetObjectGlobalVar(fid, value)
	unsigned short	fid
	void *	value
    
long
PBVM::SetArrayGlobalVar(fid, value)
	unsigned short	fid
	void *	value
    
short
PBVM::IsNativeObject(obj)
	void *	obj
    
void *
PBVM::NewBoundedSimpleArray(type, boundaries)
	unsigned short	type
	AV *	boundaries
    
void *
PBVM::NewUnboundedSimpleArray(type)
	unsigned short	type
    
void *
PBVM::NewBoundedObjectArray(cl, dimensions, bounds)
	void *	cl
	unsigned short	dimensions
	void *	bounds
    
void *
PBVM::NewUnboundedObjectArray(c)
	void *	c
    
long
PBVM::GetArrayLength(a)
	void *	a
    
void *
PBVM::GetArrayInfo(a)
	void *	a
    
long
PBVM::ReleaseArrayInfo(a)
	void *	a
    
short
PBVM::IsArrayItemNull(array, dim_array)
	void *	array
	AV *	dim_array
    
void
PBVM::SetArrayItemToNull(array, dim_array)
	void *	array
	AV *	dim_array
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->SetArrayItemToNull(array,dim_array);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

unsigned short
PBVM::GetArrayItemType(array, dim_array)
	void *	array
	AV *	dim_array
    
short
PBVM::GetIntArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
long
PBVM::GetLongArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
float
PBVM::GetRealArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
double
PBVM::GetDoubleArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
void *
PBVM::GetDecArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
void *
PBVM::GetStringArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
short
PBVM::GetBoolArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
unsigned short
PBVM::GetUintArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
unsigned long
PBVM::GetUlongArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
void *
PBVM::GetBlobArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
void *
PBVM::GetDateArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
void *
PBVM::GetTimeArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
void *
PBVM::GetDateTimeArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
unsigned short
PBVM::GetCharArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
void *
PBVM::GetObjectArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
long
PBVM::SetIntArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	short	v
    
long
PBVM::SetLongArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	long	v
    
long
PBVM::SetRealArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	float	v
    
long
PBVM::SetDoubleArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	double	v
    
long
PBVM::SetDecArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	void *	v
    
long
PBVM::SetPBStringArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	void *	v
    
long
PBVM::SetStringArrayItem(array, dim_array, s)
	void *	array
	AV *	dim_array
	char *	s
    
long
PBVM::SetBoolArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	short	v
    
long
PBVM::SetUintArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	unsigned short	v
    
long
PBVM::SetUlongArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	unsigned long	v
    
long
PBVM::SetBlobArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	void *	v
    
long
PBVM::SetDateArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	void *	v
    
long
PBVM::SetTimeArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	void *	v
    
long
PBVM::SetDateTimeArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	void *	v
    
long
PBVM::SetCharArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	unsigned short	v
    
long
PBVM::SetObjectArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	void *	v
    
void *
PBVM::NewProxyObject(cls)
	void *	cls
    
long
PBVM::SetMarshaler(obj, marshaler)
	void *	obj
	void *	marshaler
    
void *
PBVM::GetMarshaler(obj)
	void *	obj
    
void *
PBVM::AcquireValue(value)
	void *	value
    
void *
PBVM::AcquireArrayItemValue(arr, dim_array)
	void *	arr
	AV *	dim_array
    
void
PBVM::SetValue(dest, src)
	void *	dest
	void *	src
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->SetValue(dest,src);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
PBVM::SetArrayItemValue(arr, dim_array, src)
	void *	arr
	AV *	dim_array
	void *	src
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->SetArrayItemValue(arr,dim_array,src);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
PBVM::ReleaseValue(value)
	void *	value
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->ReleaseValue(value);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
PBVM::SetProp(name, data)
	char *	name
	void *	data
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->SetProp(name,data);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void *
PBVM::GetProp(name)
	char *	name
    
void
PBVM::RemoveProp(name)
	char *	name
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->RemoveProp(name);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

short
PBVM::ProcessPBMessage()
    
long
PBVM::GetEnumItemValue(enumName, enumItemName)
	char *	enumName
	char *	enumItemName
    
char *
PBVM::GetEnumItemName(enumName, enumItemValue)
	char *	enumName
	long	enumItemValue
    
void *
PBVM::GetPBAnyField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetPBAnySharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetPBAnyGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
void *
PBVM::GetPBAnyArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
void *
PBVM::CreateResultSet(rs)
	void *	rs
    
void
PBVM::ReleaseResultSetAccessor(rs)
	void *	rs
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->ReleaseResultSetAccessor(rs);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

short
PBVM::RestartRequested()
    
short
PBVM::HasPBVisualObject()
    
void
PBVM::SetDebugTrace(traceFile)
	char *	traceFile
    PREINIT:
	I32 *	__temp_markstack_ptr;
    PPCODE:
	__temp_markstack_ptr = PL_markstack_ptr++;
	THIS->SetDebugTrace(traceFile);
        if (PL_markstack_ptr != __temp_markstack_ptr) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = __temp_markstack_ptr;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

long
PBVM::AddByteArgument(ci, value, ...)
	void *	ci
	unsigned char	value
    PREINIT:
	short	isNull;
    CODE:
switch(items-1) {
case 3:
	isNull = (short)SvIV(ST(2));
	RETVAL = THIS->AddByteArgument(ci,value,isNull);
	break; /* case 3 */
default:
	RETVAL = THIS->AddByteArgument(ci,value);
} /* switch(items) */ 
    OUTPUT:
RETVAL

unsigned short
PBVM::GetByteField(obj, fid, isNullsv)
	void *	obj
	unsigned short	fid
	SV *	isNullsv
    
long
PBVM::SetByteField(obj, fid, value)
	void *	obj
	unsigned short	fid
	unsigned char	value
    
unsigned short
PBVM::GetByteSharedVar(group, fid, isNullsv)
	void *	group
	unsigned short	fid
	SV *	isNullsv
    
long
PBVM::SetByteSharedVar(group, fid, value)
	void *	group
	unsigned short	fid
	unsigned char	value
    
unsigned short
PBVM::GetByteGlobalVar(fid, isNullsv)
	unsigned short	fid
	SV *	isNullsv
    
long
PBVM::SetByteGlobalVar(fid, value)
	unsigned short	fid
	unsigned char	value
    
unsigned short
PBVM::GetByteArrayItem(array, dim_array, isNullsv)
	void *	array
	AV *	dim_array
	SV *	isNullsv
    
long
PBVM::SetByteArrayItem(array, dim_array, v)
	void *	array
	AV *	dim_array
	unsigned short	v
    
MODULE = Powerbuilder::PBVM     	PACKAGE = Powerbuilder	

PROTOTYPES: DISABLE

