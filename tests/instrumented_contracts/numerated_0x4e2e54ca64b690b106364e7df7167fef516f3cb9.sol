1 /*
2 The MaxiPRO Contract.
3 
4 The MaxiPRO Contract is free software: you can redistribute it and/or
5 modify.
6 @author Ivan Fedorov 
7 twitter https://twitter.com/maxipro_pro
8 bitcointalk https://bitcointalk.org/index.php?topic=4336550
9 telegram https://t.me/Maxipro_pro
10 medium https://medium.com/@maxipro_pro
11 contact e-mail: info@maxipro.pro
12 */
13 
14 
15 
16 
17  pragma solidity ^0.4.16; 
18     contract owned {
19         address public owner;
20 
21         function owned() {
22             owner = msg.sender;
23         }
24 
25         modifier onlyOwner {
26             require(msg.sender == owner);
27             _;
28         }
29 
30         function transferOwnership(address newOwner) onlyOwner {
31             owner = newOwner;
32         }
33     }
34 		
35 	contract Crowdsale is owned {
36     
37     uint256 public totalSupply;
38     mapping (address => uint256) public balanceOf;
39 	  mapping (address => bool) public frozenAccount;
40       event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     function Crowdsale() payable owned() {
43         totalSupply = 1000000000;
44         balanceOf[this] = 400000000; // public sale
45 		balanceOf[0x552e7F467CAF7FaBCEcaFdF3e986d093F85c5762] = 300000000; // team
46 		balanceOf[0x8Caa69e596CCE4A5EbaE0Efe44765573EDCa70CE] = 200000000; // for development and support of investment instrument
47 		balanceOf[0x4d989F62Dc0133d82Dbe8378a9d6542F3b0ABee5] = 8750000; // closed sale 
48 		balanceOf[0xA81A580813c3b187a8A2B6b67c555b10C73614fa] = 2500000; // closed sale 
49 		balanceOf[0x08c68BB69532EaaAF5d62B3732A2b7b7ABd74394] = 10000000; // closed sale 
50 		balanceOf[0x829ac84591641639A7b8C7150b7CF3e753778cd8] = 6250000; // closed sale 
51 		balanceOf[0xae8b76e01EBcd0e2E8b190922F08639D42abc0c9] = 3250000; // closed sale 
52 		balanceOf[0x78C2bd83Fd47ea35C6B4750AeFEc1a7CF1a2Ad0a] = 2000000; // closed sale 
53 		balanceOf[0x24e7d49CBF4108473dBC1c7A4ADF0De28CaF4148] = 4125000; // closed sale 
54 		balanceOf[0x322D5BA67bdc48ECC675546C302DB6B5d7a0C610] = 5250000; // closed sale 
55 		balanceOf[0x2e43daE28DF4ef8952096721eE22602344638979] = 8750000; // closed sale 
56 		balanceOf[0x3C36A7F610C777641fcD2f12B0D82917575AB7dd] = 3750000; // closed sale 
57 		balanceOf[0xDCE1d58c47b28dfe22F6B334E5517a49bF7B229a] = 7500000; // closed sale 
58 		balanceOf[0x36Cbb77588E5a59124e530dEc08a3C5433cCD820] = 6750000; // closed sale 
59 		balanceOf[0x3887FCB4BC96E66076B213963FbE277Ed808345A] = 12500000; // closed sale 
60 		balanceOf[0x6658E430bBD2b97c421A8BBA13361cC83D48609C] = 6250000; // closed sale 
61 		balanceOf[0xb137178106ade0506393d2041BDf90AF542F35ED] = 2500000; // closed sale 
62 		balanceOf[0x8F551F0B6144235cB89F000BA87fDd3A6B425F2E] = 7500000; // closed sale 
63 		balanceOf[0xfC1F805de2C30af99B72B02B60ED9877660C5194] = 2375000; // closed sale 
64 	
65     }
66 
67     function () payable {
68         require(balanceOf[this] > 0);
69         uint256 tokens = 200000 * msg.value / 1000000000000000000;
70         if (tokens > balanceOf[this]) {
71             tokens = balanceOf[this];
72             uint valueWei = tokens * 1000000000000000000 / 200000;
73             msg.sender.transfer(msg.value - valueWei);
74         }
75         require(balanceOf[msg.sender] + tokens > balanceOf[msg.sender]); 
76         require(tokens > 0);
77         balanceOf[msg.sender] += tokens;
78         balanceOf[this] -= tokens;
79         Transfer(this, msg.sender, tokens);
80     }
81 }
82 contract Token is Crowdsale {
83     
84    
85     string  public name        = 'MaxiPRO';
86     string  public symbol      = "MPR";
87     uint8   public decimals    = 0;
88 
89     mapping (address => mapping (address => uint256)) public allowed;
90 
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92     event Burned(address indexed owner, uint256 value);
93 
94     function Token() payable Crowdsale() {}
95 
96     function transfer(address _to, uint256 _value) public {
97         require(balanceOf[msg.sender] >= _value);
98         require(balanceOf[_to] + _value >= balanceOf[_to]);
99         balanceOf[msg.sender] -= _value;
100         balanceOf[_to] += _value;
101         Transfer(msg.sender, _to, _value);
102 		require(!frozenAccount[msg.sender]);
103 		
104     }
105     
106     function transferFrom(address _from, address _to, uint256 _value) public {
107         require(balanceOf[_from] >= _value);
108         require(balanceOf[_to] + _value >= balanceOf[_to]);
109         require(allowed[_from][msg.sender] >= _value);
110         balanceOf[_from] -= _value;
111         balanceOf[_to] += _value;
112         allowed[_from][msg.sender] -= _value;
113         Transfer(_from, _to, _value);
114     }
115 
116     function approve(address _spender, uint256 _value) public {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119     }
120 
121     function allowance(address _owner, address _spender) public constant
122         returns (uint256 remaining) {
123         return allowed[_owner][_spender];
124     }
125     
126     function burn(uint256 _value) public {
127         require(balanceOf[msg.sender] >= _value);
128         balanceOf[msg.sender] -= _value;
129         totalSupply -= _value;
130         Burned(msg.sender, _value);
131     }
132 }
133 contract MaxiPRO is Token {
134     
135     
136     function withdraw() public onlyOwner {
137         owner.transfer(this.balance);
138     }
139      function killMe() public onlyOwner {
140         require(totalSupply == 0);
141         selfdestruct(owner);
142     }
143 }