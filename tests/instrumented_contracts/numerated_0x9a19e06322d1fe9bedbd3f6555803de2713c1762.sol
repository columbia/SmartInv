1 // SPDX-License-Identifier: MIT
2 /*
3 oooooo   oooooo     oooo oooo         o8o      .             
4  `888.    `888.     .8'  `888         `"'    .o8             
5   `888.   .8888.   .8'    888 .oo.   oooo  .o888oo  .ooooo.  
6    `888  .8'`888. .8'     888P"Y88b  `888    888   d88' `88b 
7     `888.8'  `888.8'      888   888   888    888   888ooo888 
8      `888'    `888'       888   888   888    888 . 888    .o 
9       `8'      `8'       o888o o888o o888o   "888" `Y8bod8P' 
10 */
11 
12 pragma solidity ^0.6.12;
13 pragma experimental ABIEncoderV2;
14 
15 interface IWhiteInstance {
16 
17     function token() external view returns (address);
18     function denomination() external view returns (uint256);
19     function deposit(bytes32 commitment) external payable;
20     function withdraw(
21         bytes calldata proof,
22         bytes32 root,
23         bytes32 nullifierHash,
24         address payable recipient,
25         address payable relayer,
26         uint256 fee,
27         uint256 refund
28     ) external payable;
29 }
30 
31 
32 contract WhiteProxyLight {
33 
34     event EncryptedNote(address indexed sender, bytes encryptedNote);
35 
36     function deposit(
37         IWhiteInstance _white,
38         bytes32 _commitment,
39         bytes calldata _encryptedNote
40     ) external payable {
41         _white.deposit{ value: msg.value }(_commitment);
42         emit EncryptedNote(msg.sender, _encryptedNote);
43     }
44 
45     function withdraw(
46         IWhiteInstance _white,
47         bytes calldata _proof,
48         bytes32 _root,
49         bytes32 _nullifierHash,
50         address payable _recipient,
51         address payable _relayer,
52         uint256 _fee,
53         uint256 _refund
54     ) external payable {
55         _white.withdraw{ value: msg.value }(_proof, _root, _nullifierHash, _recipient, _relayer, _fee, _refund);
56     }
57 
58     function backupNotes(bytes[] calldata _encryptedNotes) external {
59         for (uint256 i = 0; i < _encryptedNotes.length; i++) {
60         emit EncryptedNote(msg.sender, _encryptedNotes[i]);
61         }
62     }
63 }