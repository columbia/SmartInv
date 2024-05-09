1 pragma solidity ^0.4.20;
2 
3 contract Token {
4     function totalSupply() public constant returns (uint256 supply) {}
5     function balanceOf(address _owner) public constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) public returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
8     function approve(address _spender, uint256 _value) public returns (bool success) {}
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 contract StandardToken is Token {
15     function transfer(address _to, uint256 _value) public returns (bool success) {
16         if (balances[msg.sender] >= _value && _value > 0) {
17             balances[msg.sender] -= _value;
18             balances[_to] += _value;
19             Transfer(msg.sender, _to, _value);
20             return true;
21         } else { return false; }
22     }
23 
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
25         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
26             balances[_to] += _value;
27             balances[_from] -= _value;
28             allowed[_from][msg.sender] -= _value;
29             Transfer(_from, _to, _value);
30             return true;
31         } else { return false; }
32     }
33     function balanceOf(address _owner) public constant returns (uint256 balance) {
34         return balances[_owner];
35     }
36 
37     function approve(address _spender, uint256 _value) public returns (bool success) {
38         allowed[msg.sender][_spender] = _value;
39         Approval(msg.sender, _spender, _value);
40         return true;
41     }
42 
43     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
44       return allowed[_owner][_spender];
45     }
46 
47     mapping (address => uint256) balances;
48     mapping (address => mapping (address => uint256)) allowed;
49     uint256 public totalSupply;
50 }
51 
52 contract ERC827 is StandardToken {
53 
54   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
55   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
56   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
57 
58 }
59 
60 contract ERC827Token is ERC827 {
61   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
62     require(_spender != address(this));
63 
64     super.approve(_spender, _value);
65 
66     require(_spender.call(_data));
67 
68     return true;
69   }
70 
71   
72   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
73     require(_to != address(this));
74 
75     super.transfer(_to, _value);
76 
77     require(_to.call(_data));
78     return true;
79   }
80 
81   
82   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
83     require(_to != address(this));
84 
85     super.transferFrom(_from, _to, _value);
86 
87     require(_to.call(_data));
88     return true;
89   }
90 
91 }
92 
93 contract D7Contributor is ERC827Token {
94 
95     /* Combined Certificate of Value and Acknowledgment
96  2001 Virtual Land Parcels Located in the Virtual World DECENTRALAND​ in form of
97  District Contributor Tokens.
98 Issued to Contributors of District Red Lights​ aka TheSeven7vr​,
99 IDf5d8e722-fdce-4d41-b38b-adfed2e0cf6c ,Map Designator 31
100 a District in the Virtual World Known as DECENTRALAND​.
101  Valuation of Land Parcels of DISTRICT RED LIGHTS (2/23/2018)
102  By: Jeffrey Paquin aka SAAM.I.AM
103 Registered Owner/District Leader https://gist.github.com/BlacksheepAries/7ba33d10c2ae5765fc8aa384b6520938
104 To: ALL CONTRIBUTING DISTRICT MEMBERS
105 OFFICIAL DISTRICT Order Number 001
106 
107     The Value assessed by this document is Verified
108 and documented by the DECENTRALAND End of
109 Auction Statistics and utilizing the Average Price
110 per parcel near center. Due to the strategic Location
111 in relation to Center and proximity to the Vegas
112 district, these assesed VALUES are mild and lower
113 than actual potential values once commercialized.
114 And so for all legal reference and purpose the value
115 per Parcel is 46,149MANA x .20USD =
116 $9,229.80 USD
117 
118 I declare that the assessed Values assigned to the District Red Lights Membership Tokens
119 are of fair and true value, documented and verifiable as per supporting documentation herein mentioned;
120 and further backed by contract address 0x0f5d2fb29fb7d3cfee444a200298f468908cc942 as the currency
121 address utilized in the purchase/staking period.
122 Signature…Jeffrey Paquin Owner/District Leader
123     For more details, reference our District CCVO document at http://www.the7vr.org/pdf/CCVOredlightsvaluation.pdf
124     */
125     
126     string public name;                  
127     uint8 public decimals;                
128     string public symbol;                 
129 
130     function D7Contributor() public {
131         balances[msg.sender] = 4002;
132         totalSupply = 4002;
133         name = "District 7 Contributor";
134         decimals = 0;
135         symbol = "D7C";
136     }
137 
138 }