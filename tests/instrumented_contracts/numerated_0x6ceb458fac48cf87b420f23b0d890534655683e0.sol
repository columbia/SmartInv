1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4     function totalSupply() constant returns (uint256 supply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract FBT is ERC20 {
15     mapping (address => uint256) balances;
16     mapping (address => mapping (address => uint256)) allowed;
17     mapping (address => bytes1) addresslevels;
18     mapping (address => uint256) feebank;
19  
20     uint256 public totalSupply;
21     uint256 public pieceprice;
22     uint256 public datestart;
23     uint256 public totalaccumulated;
24   
25     address dev1 = 0xFAB873F0f71dCa84CA33d959C8f017f886E10C63;
26     address dev2 = 0xD7E9aB6a7a5f303D3Cd17DcaEFF254D87757a1F8;
27 
28     function transfer(address _to, uint256 _value) returns (bool success) {
29         if (balances[msg.sender] >= _value && _value > 0) {
30             balances[msg.sender] -= _value;
31             balances[_to] += _value;
32             Transfer(msg.sender, _to, _value);
33           
34             refundFees();
35             return true;
36         } else revert();
37     }
38 
39     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
40         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
41             balances[_to] += _value;
42             balances[_from] -= _value;
43             allowed[_from][msg.sender] -= _value;
44             Transfer(_from, _to, _value);
45           
46             refundFees();
47             return true;
48         } else revert();
49     }
50   
51     function balanceOf(address _owner) constant returns (uint256 balance) {
52         return balances[_owner];
53     }
54 
55     function approve(address _spender, uint256 _value) returns (bool success) {
56         allowed[msg.sender][_spender] = _value;
57         Approval(msg.sender, _spender, _value);
58         return true;
59     }
60 
61     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
62         return allowed[_owner][_spender];
63     }
64    
65     function refundFees() {
66         uint256 refund = 200000*tx.gasprice;
67         if (feebank[msg.sender]>=refund) {
68             msg.sender.transfer(refund);
69             feebank[msg.sender]-=refund;
70         }       
71     }
72 }
73 
74 
75 contract FrostByte is FBT {
76     event tokenBought(uint256 totalTokensBought, uint256 Price);
77     event etherSent(uint256 total);
78    
79     string public name;
80     uint8 public decimals;
81     string public symbol;
82     string public version = '0.4';
83   
84     function FrostByte() {
85         name = "FrostByte";
86         decimals = 4;
87         symbol = "FBT";
88         pieceprice = 1 ether / 256;
89         datestart = now;
90     }
91 
92     function () payable {
93         bytes1 addrLevel = getAddressLevel();
94         uint256 generateprice = getPrice(addrLevel);
95         if (msg.value<generateprice) revert();
96 
97         uint256 seventy = msg.value / 100 * 30;
98         uint256 dev = seventy / 2;
99         dev1.transfer(dev);
100         dev2.transfer(dev);
101         totalaccumulated += seventy;
102 
103         uint256 generateamount = msg.value * 10000 / generateprice;
104         totalSupply += generateamount;
105         balances[msg.sender]=generateamount;
106         feebank[msg.sender]+=msg.value-seventy;
107        
108         refundFees();
109         tokenBought(generateamount, msg.value);
110     }
111    
112     function sendEther(address x) payable {
113         x.transfer(msg.value);
114         refundFees();
115 
116         etherSent(msg.value);
117     }
118    
119     function feeBank(address x) constant returns (uint256) {
120         return feebank[x];
121     }
122    
123     function getPrice(bytes1 addrLevel) constant returns (uint256) {
124         return pieceprice * uint256(addrLevel);
125     }
126    
127     function getAddressLevel() returns (bytes1 res) {
128         if (addresslevels[msg.sender]>0) return addresslevels[msg.sender];
129       
130         bytes1 highest = 0;
131         for (uint256 i=0;i<20;i++) {
132             bytes1 c = bytes1(uint8(uint(msg.sender) / (2**(8*(19 - i)))));
133             if (bytes1(c)>highest) highest=c;
134            
135         }
136       
137         addresslevels[msg.sender]=highest;
138         return highest;
139     }
140  
141     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
142         allowed[msg.sender][_spender] = _value;
143         Approval(msg.sender, _spender, _value);
144 
145         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
146         return true;
147     }
148 }