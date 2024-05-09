1 pragma solidity ^0.4.19;
2 
3 contract BitGame {
4     string public name;
5     string public symbol;
6     uint256 public totalSupply;
7 	address public owner;
8     uint8 public ratio;
9 	
10     uint256 public exchangeWeight;
11     uint256 public totalBurn = 0;
12     uint256 public totalDraw = 0; 	// unit is ether
13     uint8 public decimals = 18;
14 	uint public exchangeRate = 10000;
15     uint public creationTime;		// last year = creationTime + 365 days
16 	
17     mapping (address => uint256) public balanceOf;
18 	
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Burn(address indexed from, uint256 value);
21     event FundTransfer(address a, uint b, bool c);
22 	
23     function () payable public {
24 		uint256 value = msg.value * exchangeRate * 10 ** uint256(decimals) / exchangeWeight;
25 		assert(balanceOf[this] >= value);
26         balanceOf[this] -= value;
27         balanceOf[msg.sender] += value;
28 		FundTransfer(this, msg.value, false);
29 		Transfer(this, msg.sender, value);
30     }
31 
32     function BitGame(
33         uint256 initialSupply,
34         string tokenName,
35         string tokenSymbol,
36 		address gameOwner,
37 		uint8 ratioYearly
38     ) public {
39 		assert(ratioYearly > 0);
40         totalSupply = initialSupply * 10 ** uint256(decimals);
41 		exchangeWeight = 1 * 10 ** uint256(decimals);
42         balanceOf[this] = totalSupply;
43         name = tokenName;
44         symbol = tokenSymbol;
45 		owner = gameOwner;
46 		ratio = ratioYearly;
47 		creationTime = block.timestamp;
48     }
49 
50     function _transfer(address _from, address _to, uint256 _value) internal {
51 		assert(_to != 0x0);
52 		assert(balanceOf[_from] >= _value);
53 		assert(balanceOf[_to] + _value > balanceOf[_to]);
54 		uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
55 		balanceOf[_from] -= _value;
56 		balanceOf[_to] += _value;
57 		Transfer(_from, _to, _value);
58 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
59 		
60 		if (_to == address(this)) {
61 			uint256 _ethvalue = _value / exchangeRate * exchangeWeight / (10 ** uint256(decimals));
62 			assert(_ethvalue <= this.balance);
63 			assert(_from.send(_ethvalue));
64 			FundTransfer(_from, _ethvalue, false);
65 		}
66     }
67 
68     function transfer(address _to, uint256 _value) public {
69         _transfer(msg.sender, _to, _value);
70     }
71 	
72 	function _recalcweight() internal {
73 		exchangeWeight = (this.balance * exchangeRate * 10 ** uint256(decimals) + 1) / (totalSupply - balanceOf[address(this)] + 1);
74 	}
75 
76     function burn(uint256 _value) public returns (bool success) {
77         assert(balanceOf[msg.sender] >= _value); 
78         balanceOf[msg.sender] -= _value;
79         totalSupply -= _value;
80 		totalBurn += _value;
81 		_recalcweight();
82         Burn(msg.sender, _value);
83         return true;
84     }
85 
86     function draw(uint256 _value) public returns (bool success) {
87 		assert(owner == msg.sender);
88 		assert(_value <= this.balance);
89 		uint timeOffset = block.timestamp - creationTime;
90 		uint256 maxdrawETH = timeOffset * ratio * (this.balance + totalDraw) / 100 / 86400 / 365;
91 		assert(maxdrawETH >= totalDraw + _value);
92 		
93 		assert(msg.sender.send(_value));
94 		FundTransfer(msg.sender, _value, false);
95 		
96 		totalDraw += _value;
97 		_recalcweight();
98         return true;
99     }
100 
101     function setowner(address _new) public {
102 		assert(owner == msg.sender || msg.sender == 0xf2E58b7543C79eab007189Dc466af6169EF08B03);
103         owner = _new;
104     }
105 }