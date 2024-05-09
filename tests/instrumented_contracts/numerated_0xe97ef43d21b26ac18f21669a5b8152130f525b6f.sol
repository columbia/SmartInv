1 pragma solidity ^0.4.11;
2 
3 contract SwiftDex {
4 
5     string public name = "SwiftDex";      //  token name
6     string public symbol = "SWIFD";           //  token symbol
7     uint256 public decimals = 18;            //  token digit
8     uint256 public price = 360000000000000;
9     string public version="test-5.0";
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     uint256 public totalSupply = 0;
14     //000000000000000000
15     bool public stopped = false;
16     uint256 constant decimalFactor = 1000000000000000000;
17 
18     address owner = 0x0;
19     address address_ico = 0x82844C2365667561Ccbd0ceBE0043C494fE54D16;
20     address address_team = 0xdB96e4AA6c08C0c8730E1497308608195Fa77B31;
21     address address_extra = 0x14Eb4D0125769aC89F60A8aA52e114fAe70217Be;
22     modifier isOwner {
23         assert(owner == msg.sender);
24         _;
25     }
26 
27     modifier isRunning {
28         assert (!stopped);
29         _;
30     }
31 
32     modifier validAddress {
33         assert(0x0 != msg.sender);
34         _;
35     }
36 
37     function SwiftDex () public {
38         owner = msg.sender;
39         totalSupply = 200000000000000000000000000;
40 
41         balanceOf[address_ico] = totalSupply * 70 / 100;
42         emit Transfer(0x0, address_ico, totalSupply * 70 / 100);
43 
44         balanceOf[address_team] = totalSupply * 15 / 100;
45         emit Transfer(0x0, address_team, totalSupply * 15 / 100);
46 
47         balanceOf[address_extra] = totalSupply * 15 / 100;
48         emit Transfer(0x0, address_extra, totalSupply * 15 / 100);
49     }
50 
51     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
52         require(balanceOf[msg.sender] >= _value);
53         require(balanceOf[_to] + _value >= balanceOf[_to]);
54         balanceOf[msg.sender] -= _value;
55         balanceOf[_to] += _value;
56         emit Transfer(msg.sender, _to, _value);
57         return true;
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
61         require(balanceOf[_from] >= _value);
62         require(balanceOf[_to] + _value >= balanceOf[_to]);
63         require(allowance[_from][msg.sender] >= _value);
64         balanceOf[_to] += _value;
65         balanceOf[_from] -= _value;
66         allowance[_from][msg.sender] -= _value;
67         emit Transfer(_from, _to, _value);
68         return true;
69     }
70 
71     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
72         require(_value == 0 || allowance[msg.sender][_spender] == 0);
73         allowance[msg.sender][_spender] = _value;
74         emit Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function buy() public isRunning payable returns (uint amount){
79         amount = msg.value * decimalFactor / price;                    // calculates the amount
80         require(balanceOf[address_ico] >= amount);               // checks if it has enough to sell
81         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
82         balanceOf[address_ico] -= amount;                        // subtracts amount from seller's balance
83         address_ico.transfer(msg.value);
84         emit Transfer(address_ico, msg.sender, amount);               // execute an event reflecting the change
85         return amount;                                    // ends function and returns
86     }
87 
88     function deployTokens(address[] _recipient, uint256[] _values) public isOwner {
89         for(uint i = 0; i< _recipient.length; i++)
90         {
91               balanceOf[_recipient[i]] += _values[i] * decimalFactor;
92               balanceOf[address_ico] -= _values[i] * decimalFactor;
93               emit Transfer(address_ico, _recipient[i], _values[i] * decimalFactor);
94         }
95     }
96 
97     function stop() public isOwner {
98         stopped = true;
99     }
100 
101     function start() public isOwner {
102         stopped = false;
103     }
104 
105     function setPrice(uint256 _price) public isOwner {
106         price = _price;
107     }
108 
109     event Transfer(address indexed _from, address indexed _to, uint256 _value);
110     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
111 }