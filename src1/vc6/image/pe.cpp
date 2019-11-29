/* __pe_source__ */

#include "pe.h"

/************************************************************************/
/* ��ȡPE DOS                                                           */
/************************************************************************/
PIMAGE_DOS_HEADER pe_dos_header(__in pvoid addr)
{
	return (PIMAGE_DOS_HEADER)addr;
}

/************************************************************************/
/* ��ȡPE NT                                                            */
/************************************************************************/
PIMAGE_NT_HEADERS pe_nt_header(__in pvoid addr)
{
	return (PIMAGE_NT_HEADERS)((puchar)addr + pe_dos_header(addr)->e_lfanew);
}

/************************************************************************/
/* ��ȡPE FILE                                                          */
/************************************************************************/
PIMAGE_FILE_HEADER pe_file_header(__in pvoid addr)
{
	return & pe_nt_header(addr)->FileHeader;
}

/************************************************************************/
/* ��ȡPE OPTIONAL                                                      */
/************************************************************************/
PIMAGE_OPTIONAL_HEADER pe_optional_header(__in pvoid addr)
{
	return & pe_nt_header(addr)->OptionalHeader;
}

/************************************************************************/
/* ��ȡDATA DIRECTORY                                                   */
/************************************************************************/
PIMAGE_DATA_DIRECTORY pe_data_directory(__in pvoid addr, __in uint index)
{
	return & pe_optional_header(addr)->DataDirectory[index];
}

/************************************************************************/
/* ��ȡSECTION HEADER                                                   */
/************************************************************************/
PIMAGE_SECTION_HEADER pe_section_header(__in pvoid addr, __in uint index)
{
	return & IMAGE_FIRST_SECTION(pe_nt_header(addr))[index];
}

/************************************************************************/
/* ����Ƿ�Ϸ�PE�ļ�                                                   */
/************************************************************************/
bool pe_is(__in pvoid addr)
{
	return (pe_dos_header(addr)->e_magic == IMAGE_DOS_SIGNATURE && pe_nt_header(addr)->Signature == IMAGE_NT_SIGNATURE);
}

/************************************************************************/
/* ����Ƿ�DLL�ļ�                                                      */
/************************************************************************/
bool pe_is_dll(__in pvoid addr)
{
	return (pe_file_header(addr)->Characteristics & IMAGE_FILE_DLL) == IMAGE_FILE_DLL;
}