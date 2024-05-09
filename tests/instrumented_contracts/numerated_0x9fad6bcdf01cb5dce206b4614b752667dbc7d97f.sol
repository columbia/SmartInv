1 pragma solidity ^0.4.13;
2 
3 
4 contract Notary {
5     
6     address public jan = 0x45f5c8b556c3f2887b50184c823d1223f41a4156;
7     address public investor = 0xCF4e87991826081d172B61b2e1B2800F18dA8cE7;
8 
9     address NotaryPersistentStorageAddress = 0x8439dacB099826eba3c56A8B2d3A15F108a89552;
10 
11     event LogResponse(bytes32, bool);
12 
13     function Notary() payable {
14     }
15 
16     function notarise(bytes32 _proof) public payable returns (bool success) {
17         
18         NotaryPersistentStorage notary = NotaryPersistentStorage(NotaryPersistentStorageAddress);
19         notary.storeProof(_proof);
20 
21         _payRoyalty();
22         
23         return true;
24     }
25 
26     function hasProof(bytes32 _proof) public returns (bool) {
27         NotaryPersistentStorage notary = NotaryPersistentStorage(NotaryPersistentStorageAddress);
28         bool result = notary.hasProof(_proof);
29         LogResponse(_proof,result);
30         return result;
31     }
32     
33     function _payRoyalty() public payable {
34         uint amount = msg.value;
35         jan.transfer(amount/2);
36         investor.transfer(amount/2);
37     }
38     
39     // fallback function
40     function () payable {
41     }
42     
43 }
44 
45 
46 contract NotaryPersistentStorage {
47     function storeProof(bytes32 _proof) public returns (bool);
48     function hasProof(bytes32 _proof) public constant returns (bool);
49 }