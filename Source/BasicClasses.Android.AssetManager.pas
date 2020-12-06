{===============================================================================

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

===============================================================================}

{$INCLUDE BasicClasses.Config.inc}

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   <para>
///     Android NDK C/C++ files: <br />android/asset_manager.h <br />
///     android/asset_manager_jni.h
///   </para>
///   <para>
///     Orginal source code was taken from: <br />
///     %NDK_DIR%/platforms/android-9.arch-arm/usr/include
///   </para>
///   <para>
///     Pascal translation by Piotr Domañski, November 2018
///   </para>
/// </summary>
/// <remarks>
///   <para>
///     Copyright (C) 2010 The Android Open Source Project
///   </para>
///   <para>
///     Dependencies:
///   </para>
///   <list type="bullet">
///     <item>
///       Lib.TypeDefinitions - github.com/dompiotr85/Lib.TypeDefinitions
///     </item>
///   </list>
///   Version 0.1.2
/// </remarks>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
unit BasicClasses.Android.AssetManager;

interface

{$IFDEF SUPPORTS_LEGACYIFEND}{$LEGACYIFEND ON}{$ENDIF}

{$IF DEFINED(ANDROID)}

{$INCLUDE BasicClasses.Android.Config.inc}

uses
  unixtype, jni;

{$INCLUDE BasicClasses.Android.LibDefs.inc}

type
  Poff_t = ^off_t;
  Poff64_t = ^off64_t;

  PAAssetManager = ^AAssetManager;
  AAssetManager = record
  end;

  PAAssetDir = ^AAssetDir;
  AAssetDir = record
  end;

  PAAsset = ^AAsset;
  AAsset = record
  end;

const
  { Available modes for opening assets. }
  AASSET_MODE_UNKNOWN = 0;
  AASSET_MODE_RANDOM = 1;
  AASSET_MODE_STREAMING = 2;
  AASSET_MODE_BUFFER = 3;

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Given a Dalvik AssetManager object, obtain the corresponding native
///   AAssetManager object.
/// </summary>
/// <remarks>
///   Note that the caller is responsible for obtaining and holding a VM
///   reference to the jobject to prevent its being garbage collected while the
///   native object is in use.
/// </remarks>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function AAssetManager_fromJava(env: PJNIEnv; assetManager: jobject): PAAssetManager; cdecl; external libandroid name 'AAssetManager_fromJava';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Open the named directory within the asset hierarchy. The directory can
///   then be inspected with the AAssetDir function. To open the top-level
///   directory, pass in "" as the dirName.
/// </summary>
/// <remarks>
///   The object returned here should be freed by calling
///   <see cref="BasicClasses.Android.AssetManager|AAsset_close(PAAsset)">
///   AAssetDir_close()</see>.
/// </remarks>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function AAssetManager_openDir(mgr: PAAssetManager; dirName: PAnsiChar): PAAssetDir; cdecl; external libandroid name 'AAssetManager_openDir';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Open an asset.
/// </summary>
/// <remarks>
///   The object returned here should be freed by calling
///   <see cref="BasicClasses.Android.AssetManager|AAsset_close(PAAsset)">
///   AAsset_close()</see>.
/// </remarks>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function AAssetManager_open(mgr: PAAssetManager; filename: PAnsiChar; Mode: LongInt): PAAsset; cdecl; external libandroid name 'AAssetManager_open';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Itterate over the files in an asset directory. A NULL string is returned
///   when all the file names have been returned. The returned file name is
///   suitable for passing to
///   <see cref="BasicClasses.Android.AssetManager|AAssetManager_open(PAAssetManager,PAnsiChar,LongInt)">
///   AAssetManager_open()</see>.
/// </summary>
/// <remarks>
///   The string returned here is owned by the AssetDir implementation and is
///   not guaranteed to remain valid if any other calls are made on this
///   AAssetDir instance.
/// </remarks>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function AAssetDir_getNextFileName(assetDir: PAAssetDir): PAnsiChar; cdecl; external libandroid name 'AAssetDir_getNextFileName';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Reset the itteration state of
///   <see cref="BasicClasses.Android.AssetManager|AAssetDir_getNextFileName(PAAssetDir)">
///   AAssetDir_getNextFileName()</see> to the beginning.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
procedure AAssetDir_rewind(assetDir: PAAssetDir); cdecl; external libandroid name 'AAssetDir_rewind';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Close an opened AAssetDir, freeing any related resources.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
procedure AAssetDir_close(assetDir: PAAssetDir); cdecl; external libandroid name 'AAssetDir_close';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Attempt to read 'count' bytes of data from the current offset. Returns
///   the number of bytes read, zero on EOF, or &lt; 0 on error.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function AAsset_read(asset: PAAsset; buf: Pointer; count: size_t): LongInt; cdecl; external libandroid name 'AAsset_read';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Seek to the specified offset within the asset data. 'whence' uses the
///   same constants as lseek()/fseek(). Returns the new position on success,
///   or (off_t) -1 on error.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function AAsset_seek(asset: PAAsset; offset: off_t; whence: LongInt): off_t; cdecl; external libandroid name 'AAsset_seek';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Seek to the specified offset within the asset data. 'whence' uses the
///   same constants as lseek()/fseek(). Uses 64-bit data type for large files
///   as opposed to the 32-bit type used by AAsset_seek. Returns the new
///   position on success, or (off64_t) -1 on error.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function AAsset_seek64(asset: PAAsset; offset: off64_t; whence: LongInt): off64_t; cdecl; external libandroid name 'AAsset_seek64';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Close the asset, freeing all associated resources.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
procedure AAsset_close(asset: PAAsset); cdecl; external libandroid name 'AAsset_close';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Get a pointer to a buffer holding the entire contents of the asset.
///   Returns nil on failure.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function AAsset_getBuffer(asset: PAAsset): Pointer; cdecl; external libandroid name 'AAsset_getBuffer';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Report the total size of the asset data.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function AAsset_getLength(asset: PAAsset): off_t; cdecl; external libandroid name 'AAsset_getLength';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Report the total size of the asset data. Reports the size using a 64-bit
///   number instead of 32-bit as
///   <see cref="BasicClasses.Android.AssetManager|AAsset_getLength(PAAsset)">
///   AAsset_getLength()</see>.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function AAsset_getLength64(asset: PAAsset): off64_t; cdecl; external libandroid name 'AAsset_getLength64';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Report the total amount of asset data that can be read from the current
///   position.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function AAsset_getRemainingLength(asset: PAAsset): off_t; cdecl; external libandroid name 'AAsset_getRemainingLength';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Report the total amount of asset data that can be read from the current
///   position.
/// </summary>
/// <remarks>
///   Uses a 64-bit number instead of a 32-bit number as
///   <see cref="BasicClasses.Android.AssetManager|AAsset_getRemainingLength(PAAsset)">
///   AAsset_getRemainingLength()</see> does.
/// </remarks>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function AAsset_getRemainingLength64(asset: PAAsset): off64_t; cdecl; external libandroid name 'AAsset_getRemainingLength64';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Open a new file descriptor that can be used to read the asset data.
///   Returns &lt; 0 if direct fd access is not possible (for example, if the
///   asset is compressed).
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function AAsset_openFileDescriptor(asset: PAAsset; outStart, outLength: Poff_t): LongInt; cdecl; external libandroid name 'AAsset_openFileDescriptor';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Open a new file descriptor that can be used to read the asset data.
///   Returns &lt; 0 if direct fd access is not possible (for example, if the
///   asset is compressed).
/// </summary>
/// <remarks>
///   Uses a 64-bit number for the offset and length instead of 32-bit number
///   of as
///   <see cref="BasicClasses.Android.AssetManager|AAsset_openFileDescriptor(PAAsset,Poff_t,Poff_t)">
///   AAsset_openFileDescriptor()</see> does.
/// </remarks>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function AAsset_openFileDescriptor64(asset: PAAsset; outStart, outLength: Poff64_t): LongInt; cdecl; external libandroid name 'AAsset_openFileDescriptor64';

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Returns whether this asset's internal buffer is allocated in ordinary RAM
///   (i.e. not mmapped).
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function AAsset_isAllocated(asset: PAAsset): LongInt; cdecl; external libandroid name 'AAsset_isAllocated';
{$IFEND}

implementation

end.
