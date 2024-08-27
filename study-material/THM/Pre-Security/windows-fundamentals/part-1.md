

- The file system used in modern versions of Windows is the New Technology File System or simply NTFS.
- Before NTFS, there was FAT16/FAT32 (File Allocation Table) and HPFS (High Performance File System). 
- NTFS is known as a journaling file system. In case of a failure, the file system can automatically repair the folders/files on disk using information stored in a log file. This function is not possible with FAT.   
- NTFS addresses many of the limitations of the previous file systems; such as: 

    Supports files larger than 4GB
    Set specific permissions on folders and files
    Folder and file compression
    Encryption (Encryption File System or EFS)

- On NTFS volumes, you can set permissions that grant or deny access to files and folders.

The permissions are:

    Full control
    Modify
    Read & Execute
    List folder contents
    Read
    Write

![](https://assets.tryhackme.com/additional/win-fun1/ntfs-permissions1.png)

- Another feature of NTFS is Alternate Data Streams (ADS).
- Alternate Data Streams (ADS) is a file attribute specific to Windows NTFS (New Technology File System). 

- Every file has at least one data stream ($DATA), and ADS allows files to contain more than one stream of data. Natively Window Explorer doesn't display ADS to the user. There are 3rd party executables that can be used to view this data, but Powershell gives you the ability to view ADS for files.
- From a security perspective, malware writers have used ADS to hide data.
- Not all its uses are malicious. For example, when you download a file from the Internet, there are identifiers written to ADS to identify that the file was downloaded from the Internet.

- The Windows folder (C:\Windows) is traditionally known as the folder which contains the Windows operating system. 
- This is where environment variables, more specifically system environment variables, come into play. Even though not discussed yet, the system  environment variable for the Windows directory is %windir%.
- Per Microsoft, "Environment variables store information about the operating system environment. This information includes details such as the operating system path, the number of processors used by the operating system, and the location of temporary folders".

- The System32 folder holds the important files that are critical for the operating system. 

- Local User and Group Management - `lusrmgr.msc`.

- To protect the local user with such privileges, Microsoft introduced User Account Control (UAC). 
- How does UAC work? When a user with an account type of administrator logs into a system, the current session doesn't run with elevated permissions. When an operation requiring higher-level privileges needs to execute, the user will be prompted to confirm if they permit the operation to run. 
