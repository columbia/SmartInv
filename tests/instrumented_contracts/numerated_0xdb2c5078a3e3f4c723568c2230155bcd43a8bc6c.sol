1 pragma solidity ^0.4.11;
2 
3 contract Certificate {
4   struct Subject {
5     uint id;            
6     address validate_hash; 
7     uint birthday;      
8     string fullname;   
9     uint8 gender;       
10     uint dt_sign;       
11     uint dt_cancel;    
12   }
13   uint8 type_id;   
14   uint dt_create; 
15   address[] subjects_addr; 
16   mapping (address => Subject) subjects;
17   address _owner;       
18 
19   function Certificate(uint8 _type_id, uint _dt_create, address[] _subjects_addr) public {
20     type_id = _type_id;
21     dt_create = _dt_create;
22     subjects_addr = _subjects_addr;
23     _owner = msg.sender;
24   }
25 
26   modifier restricted_to_subject {
27       bool allowed = false;
28       for(uint i = 0; i < subjects_addr.length; i++) {
29         if (msg.sender == subjects_addr[i]) {
30           allowed = true;
31           break;
32         }
33       }
34       if (subjects[msg.sender].dt_sign != 0 || allowed == false) {
35         revert();
36       }
37       _;
38   }
39 
40   function Sign(uint _id, address _validate_hash, uint _birthday, uint8 _gender, uint _dt_sign, string _fullname) public restricted_to_subject payable {
41     subjects[msg.sender] = Subject(_id, _validate_hash, _birthday, _fullname, _gender, _dt_sign, 0);
42     if(msg.value != 0)
43       _owner.transfer(msg.value);
44   }
45 
46   function getSubject(uint index) public constant returns (uint _id, address _validate_hash, uint _birthday, string _fullname, uint8 _gender, uint _dt_sign, uint _dt_cancel) {
47     _id = subjects[subjects_addr[index]].id;
48     _validate_hash = subjects[subjects_addr[index]].validate_hash;
49     _birthday = subjects[subjects_addr[index]].birthday;
50     _fullname = subjects[subjects_addr[index]].fullname;
51     _gender = subjects[subjects_addr[index]].gender;
52     _dt_sign = subjects[subjects_addr[index]].dt_sign;
53     _dt_cancel = subjects[subjects_addr[index]].dt_cancel;
54   }
55 
56   function getCertificate() public constant returns (uint8 _type_id, uint _dt_create, uint _subjects_count) {
57     _type_id = type_id;
58     _dt_create = dt_create;
59     _subjects_count = subjects_addr.length;
60   }
61 }