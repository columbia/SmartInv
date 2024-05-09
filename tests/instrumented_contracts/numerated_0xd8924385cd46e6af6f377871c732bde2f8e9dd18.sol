1 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
2 //:                                                                                                                                                        ://
3 //:                              Pylon Token ERC20                                                                                          ://
4 //:                          https://pylon-network.org                                                                                     ://
5 //:                                                                                                                                                        ://
6 //:                                                                                                                                                        ://
7 //: This contract is just a way to complete the ERC20 functions for the                                            ://
8 //: original Pylon Token (Smart Contract 0x7703C35CfFdC5CDa8D27aa3df2F9ba6964544b6e)     ://
9 //:                                                                                                                                                        ://
10 //: Now Pylon_ERC20 takes the ownership of the original Pylon Token contract.                             ://
11 //: This means that onlyOwner functions of the original Pylon Token contract,                                 ://
12 //: (mint, burn, frezze, transferOwner) will not be possible to execute anymore.                               ://
13 //:                                                                                                                                                        ://
14 //: All this guarantees that no one can take control of the Pylon Tokens.                                          ://
15 //:                                                                                                                                                        ://
16 //:                                                                                                                                                        ://
17 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
18 
19 
20 
21 pragma solidity ^0.5.11;
22 
23 
24 //Interface to functions of the original Pylon Token smart contract. 
25 
26 contract PylonToken {
27 
28     function balanceOf(address _owner) external pure returns (uint256 balance);
29 
30     function burnFrom(address _from, uint256 _value) external returns (bool success);
31 
32     function mintToken(address _to, uint256 _value) external;
33 
34 }
35 
36 
37 
38 contract Pylon_ERC20 {
39 
40 
41     string public name = "PYLNT";               // Extended name of this contract
42     string public symbol = "PYLNT";             // Symbol of the Pylon Token
43     uint256 public decimals = 18;               // The decimals to consider
44     uint256 public totalSupply= 633858311346493889668246;  // TotalSupply of Pylon Token
45 
46     PylonToken PLNTToken;  //Pointer to the original Pylon Token Contract 
47 
48     mapping (address => mapping (address => uint256)) internal allowed;
49 
50     
51     // addrPYLNT is the address of the original Pylon Token Contract 0x7703C35CfFdC5CDa8D27aa3df2F9ba6964544b6e
52     constructor(address addrPYLNT) public {
53         
54         PLNTToken = PylonToken(addrPYLNT);      
55     }
56 
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 
60     
61     function balanceOf(address _owner) public view returns (uint256) {
62         
63         return PLNTToken.balanceOf(address(_owner));
64     }
65 
66     function transfer(address _to, uint256 _value) public returns (bool) {
67         
68         allowed[msg.sender][msg.sender] += _value;
69         return transferFrom(msg.sender, _to, _value);
70     }
71 
72     // The original Pylon Token contract lacks the transferFrom function, which is mandatory for the ERC20 standar.
73     // Below it is implemented by using the burnFrom & mintToken functions from the original contract.
74 
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
76         
77         require(_value <= allowed[_from][msg.sender]);
78         PLNTToken.burnFrom(_from, _value);
79         PLNTToken.mintToken(_to, _value);
80 
81         allowed[_from][msg.sender] -= _value;
82 
83         emit Transfer(_from, _to, _value);
84         return true;
85     }
86 
87     function approve(address _spender, uint256 _value) public returns (bool) {
88         
89         allowed[msg.sender][_spender] = _value;
90         
91         emit Approval(msg.sender, _spender, _value);
92         return true;
93     }
94 
95     function allowance(address _owner, address _spender) public view returns (uint256) {
96         
97         return allowed[_owner][_spender];
98     }
99 
100     
101     function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData) external returns (bool success) {
102         
103         tokenRecipient spender = tokenRecipient(_spender);
104         
105         if (approve(_spender, _value)) {
106             
107             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
108             return true;
109         }
110     }
111 
112 }
113 
114 
115 interface tokenRecipient {
116     
117     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
118 }