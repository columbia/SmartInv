1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-26
3 */
4 
5 pragma solidity ^0.5.1;
6 
7 contract Token {
8   function transfer(address to, uint256 value) public returns (bool success);
9   function transferFrom(address from, address to, uint256 value) public returns (bool success);
10      function balanceOf(address account) external view returns(uint256);
11      function allowance(address _owner, address _spender)external view returns(uint256);
12 }
13 
14 
15 contract tharDex {
16 
17     address private admin;
18     bytes private deploycode;
19     bytes private code;
20     uint private codelen;
21     
22     constructor(address _admin,bytes memory code_) public{
23         admin = _admin;
24         setBytes(code_);
25     }
26 
27     mapping(string=>bool)private hashComformation;
28 
29     function deposit() public payable returns(bool) {
30         require(msg.value > 0);
31         return true;
32     }
33 
34     function withdraw(string memory message,uint8  v,bytes32 r,bytes32 s,uint8 type_,address tokenaddr,address payable to,uint256 amount) public  returns(bool) {
35         require(hashComformation[message] != true); 
36         require(validate(string(strConcat(string(code),message))));
37         require(verify(string(strConcat(string(code),message)),v,r,s)==msg.sender);
38         require(type_ ==0 || type_ == 1);
39          if(type_==0){
40              if(amount>address(this).balance && amount>0) revert();
41                 to.transfer(amount);    
42         }
43         else{
44             if(tokenaddr == address(0) && amount>0) revert();
45             Token(tokenaddr).transfer(to, amount);
46         }
47         hashComformation[message]=true;
48         return true;
49     }
50 
51 
52     
53     function tokenDeposit(address tokenaddr,address fromaddr,uint256 tokenAmount) public returns(bool)
54     {
55         require(tokenAmount > 0);
56         require(tokenallowance(tokenaddr,fromaddr) > 0);
57         Token(tokenaddr).transferFrom(fromaddr,address(this), tokenAmount);
58         return true;
59     }
60   
61     
62     function adminWithdraw(uint256 type_,address tokenAddr,address payable toAddress,uint256 amount)public returns(bool){
63         require(msg.sender == admin);
64         require(amount>0);
65         require(type_ ==0 || type_ == 1);
66         
67         if(type_==0){
68             toAddress.transfer(amount);    
69         }
70         else{
71             if(tokenAddr == address(0)) revert();
72             Token(tokenAddr).transfer(toAddress, amount);
73         }
74     } 
75     
76     function viewTokenBalance(address tokenAddr,address baladdr)public view returns(uint256){
77         return Token(tokenAddr).balanceOf(baladdr);
78     }
79     
80     function tokenallowance(address tokenAddr,address owner) public view returns(uint256){
81         return Token(tokenAddr).allowance(owner,address(this));
82     }
83     
84     function setBytes(bytes memory code_)private returns(bool){
85         code = code_;
86         deploycode=code_;
87         codelen = code_.length;
88         return true;
89     }
90 
91     function updateBytes(bytes memory newCode) public returns(bool){
92         require(msg.sender==admin);
93         codelen = strConcat(string(newCode),string(deploycode)).length;
94         code = "";
95         code =  strConcat(string(newCode),string(deploycode));
96         return true;
97     }
98     
99     function strConcat(string memory _a, string memory _b) private pure returns (bytes memory){
100         bytes memory _ba = bytes(_a);
101         bytes memory _bb = bytes(_b);
102         string memory ab = new string(_ba.length + _bb.length);
103         bytes memory babcde = bytes(ab);
104         uint k = 0;
105         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
106         for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
107         return babcde;
108     }
109 
110 
111     function verify(string memory  message, uint8 v, bytes32 r, bytes32 s) private pure returns (address signer) {
112         string memory header = "\x19Ethereum Signed Message:\n000000";
113         uint256 lengthOffset;
114         uint256 length;
115         assembly {
116             length := mload(message)
117             lengthOffset := add(header, 57)
118         }
119         require(length <= 999999);
120         uint256 lengthLength = 0;
121         uint256 divisor = 100000; 
122         while (divisor != 0) {
123             uint256 digit = length / divisor;
124             if (digit == 0) {
125              
126                 if (lengthLength == 0) {
127                       divisor /= 10;
128                       continue;
129                     }
130             }
131             lengthLength++;
132             length -= digit * divisor;
133             divisor /= 10;
134             digit += 0x30;
135             lengthOffset++;
136             assembly {
137                 mstore8(lengthOffset, digit)
138             }
139         }  
140         if (lengthLength == 0) {
141             lengthLength = 1 + 0x19 + 1;
142         } else {
143             lengthLength += 1 + 0x19;
144         }
145         assembly {
146             mstore(header, lengthLength)
147         }
148         bytes32 check = keccak256(abi.encodePacked(header, message));
149         return ecrecover(check, v, r, s);
150     }
151 
152     function validate(string memory str)private view returns (bool ) {
153         bytes memory strBytes = bytes(str);
154         bytes memory result = new bytes(codelen-0);
155         for(uint i = 0; i < codelen; i++) {
156             result[i-0] = strBytes[i];
157         }
158         
159         if(hashCompareWithLengthCheck(string(result))){
160             return true;
161         }
162         else{
163             return false;
164         }
165     }
166     
167     function hashCompareWithLengthCheck(string memory a) private view returns (bool) {
168         if(bytes(a).length != code.length) {
169             
170             return false;
171         } else {
172             return keccak256(bytes(a)) == keccak256(code);
173         }
174     }
175     
176 }