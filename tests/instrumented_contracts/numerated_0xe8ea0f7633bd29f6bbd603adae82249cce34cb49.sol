1 pragma solidity ^0.4.23;
2 
3 contract UnionPay {
4     event UserPay(address from,address to,uint256 amount, uint256 amountIndeed,uint256 transId);
5     event BareUserPay(address from,uint256 amount,bytes data);  
6     
7     address public owner;  
8     address public platform;
9     mapping(bytes32 => uint8)  userReceipts;
10 
11     constructor() public {
12       owner = msg.sender;
13       platform = msg.sender;
14     }
15   
16     modifier onlyOwner() {
17       require(msg.sender == owner);
18       _;
19     }
20   
21     function transferOwnership(address newOwner) public onlyOwner {
22       if (newOwner != address(0)) {
23         owner = newOwner;
24       }
25     }
26 
27     function safePay(uint256 _transId,uint256 _feePercentage,address _to, bytes _sig) payable public returns(bool) {
28         require(_feePercentage>=0 && _feePercentage<=100);
29         require(_to != address(0));
30         require(userReceipts[getReceiptId(msg.sender,_to,_transId)] == 0);
31         require(platform!=address(0));
32 
33         bytes32 message = prefixed(keccak256(msg.sender, _to, msg.value, _feePercentage,_transId));
34 
35         require(recoverSigner(message, _sig) == platform);
36         userReceipts[getReceiptId(msg.sender,_to,_transId)] = 1;
37         
38         if (_feePercentage == 0){
39             if (msg.value > 0){
40                 _to.transfer(msg.value);
41             }
42             emit UserPay(msg.sender,_to,msg.value,msg.value,_transId);
43             return true;
44         }        
45         uint256 val = _feePercentage * msg.value;
46         assert(val/_feePercentage == msg.value);
47         val = val/100;
48         if (msg.value>val){
49             _to.transfer(msg.value - val);
50         }
51         emit UserPay(msg.sender,_to,msg.value,msg.value - val,_transId);
52         return true;
53     }
54     
55     function getReceiptId(address _from,address _to, uint256 _transId) internal pure returns(bytes32){
56         return keccak256(_from, _to,_transId);
57     }
58     
59     function receiptUsed(address _from,address _to,uint256 _transId) public view returns(bool){
60         return userReceipts[getReceiptId(_from,_to,_transId)] == 1;
61     }
62     
63     function plainPay() public payable returns(bool){
64         emit BareUserPay(msg.sender,msg.value,msg.data);
65         return true;
66     }
67     
68     function () public payable{
69         emit BareUserPay(msg.sender,msg.value,msg.data);
70     }
71     
72     function setPlatform(address _checker) public onlyOwner{
73         require(_checker!=address(0));
74         platform = _checker;
75     }
76     
77     function withdraw() public onlyOwner{
78         require(platform!=address(0));
79         platform.transfer(address(this).balance);
80     }
81     
82     function getBalance() public view returns(uint256){
83         return address(this).balance;
84     }
85 
86 
87     // Signature methods
88 
89     function splitSignature(bytes sig)
90     internal
91     pure
92     returns(uint8, bytes32, bytes32) {
93         require(sig.length == 65);
94 
95         bytes32 r;
96         bytes32 s;
97         uint8 v;
98 
99         assembly {
100             // first 32 bytes, after the length prefix
101             r: = mload(add(sig, 32))
102             // second 32 bytes
103             s: = mload(add(sig, 64))
104             // final byte (first byte of the next 32 bytes)
105             v: = byte(0, mload(add(sig, 96)))
106         }
107 
108         return (v, r, s);
109     }
110 
111     function recoverSigner(bytes32 message, bytes sig)
112     internal
113     pure
114     returns(address) {
115         uint8 v;
116         bytes32 r;
117         bytes32 s;
118 
119         (v, r, s) = splitSignature(sig);
120 
121         return ecrecover(message, v, r, s);
122     }
123 
124     // Builds a prefixed hash to mimic the behavior of eth_sign.
125     function prefixed(bytes32 hash) internal pure returns(bytes32) {
126         return keccak256("\x19Ethereum Signed Message:\n32", hash);
127     }
128 }