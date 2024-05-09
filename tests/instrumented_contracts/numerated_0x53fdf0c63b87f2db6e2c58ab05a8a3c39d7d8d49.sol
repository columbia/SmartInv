1 pragma solidity ^0.4.7;
2 contract DXContracts {
3 
4   struct Contract {
5     string contractName;
6     string contractDescription;
7     uint index;
8     bytes32 sha256sum;
9     address[] signers;
10     uint timeStamp;
11     mapping (address=>bool) hasSigned;
12     mapping (address=>string) signerName;
13     bool sealed;
14     uint numberAlreadySigned;
15   }
16   Contract[] public contracts;
17     
18     
19   function getContractSigners(bytes32 _shasum) constant returns(address[], string, string, uint)
20     {
21         return (contracts[contractIndex[_shasum]].signers, contracts[contractIndex[_shasum]].contractName, contracts[contractIndex[_shasum]].contractDescription, contracts[contractIndex[_shasum]].numberAlreadySigned);
22     }
23     
24   function checkIfSignedBy(bytes32 _shasum, address _signer) constant returns(bool)
25     {
26         uint index=contractIndex[_shasum];
27         return (contracts[index].hasSigned[_signer]);
28     }
29     
30   mapping (bytes32=>uint) public contractIndex;
31  
32   mapping (address=>bool) isAdmin;
33      
34   function DXContracts()
35   {
36     isAdmin[msg.sender]=true;
37     contracts.length++;
38   }
39      
40   function addAdmin(address _new_admin) onlyAdmin
41   {
42     isAdmin[_new_admin]=true;
43   }
44      
45   function removeAdmin(address _old_admin) onlyAdmin
46   {
47     isAdmin[_old_admin]=false;
48   }
49  
50   modifier onlyAdmin
51   {
52     if (!isAdmin[msg.sender]) throw;
53     _;
54   }
55  
56     event newContract(string name, address[] signers, string description, bytes32 sha256sum, uint index);
57   function submitNewContract(string _name, address[] _signers, string _description, bytes32 _sha256sum) onlyAdmin
58   {
59     
60     if (contractIndex[_sha256sum]!=0) throw;
61     if (_signers.length==0) throw;
62     contractIndex[_sha256sum]=contracts.length;
63     contracts.push(Contract(_name, _description, contractIndex[_sha256sum], _sha256sum, _signers, now, false, 0));
64     newContract(_name, _signers, _description, _sha256sum, contractIndex[_sha256sum]);
65   }
66     
67     
68     event signature(string name, address signer, bytes32 sha256sum);
69     event sealed(uint index, bytes32 sha256sum);
70 
71   function signContract(bytes32 _sha256sum, string _my_name, bool _I_accept) returns (bool)
72   {
73     uint index=contractIndex[_sha256sum];
74     if (contracts[index].sealed) throw;
75     bool isSigner;
76     for (uint k=0; k<contracts[index].signers.length; k++)
77     {
78         if (contracts[index].signers[k]==msg.sender) isSigner=true;
79     }
80     if (isSigner==false) throw;
81     if (!_I_accept) throw;
82     if (index==0) throw;
83     else
84       {
85 	if (!contracts[index].hasSigned[msg.sender])
86 	  {
87 	    contracts[index].numberAlreadySigned++;
88 	  }
89 	contracts[index].hasSigned[msg.sender]=true;
90 	contracts[index].signerName[msg.sender]=_my_name;
91 	signature(_my_name, msg.sender, _sha256sum);
92 	if (contracts[index].numberAlreadySigned==contracts[index].signers.length)
93 	  {
94 	    contracts[index].sealed=true;
95 	    sealed(index, _sha256sum);
96 	  }
97 	return true;
98       }
99 
100   }
101  
102  
103 }