1 pragma solidity ^0.4.17;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 contract EthereumTrustFund {
29     
30     using SafeMath for uint256;
31     
32     string public constant name   	= "Ethereum Trust Fund";
33     string public constant symbol 	= "ETRUST";
34     uint8  public constant decimals = 18;
35     uint256 public rate = 10;
36     // todo
37     uint256 public constant _totalSupply = 1000000000000;
38     uint256 public 		_totalSupplyLeft = 1000000000000;
39     uint256 tokens                       = 0;
40     // vars
41     mapping(address => uint256) balances; 
42     mapping(address => mapping(address => uint256)) allowedToSpend;
43     address public contract_owner;
44     uint256 currentBlock = 0;
45     uint256 lastblock    = 0;
46     // init function
47     function EthereumTrustFund() public{
48     	currentBlock = block.number;
49     	lastblock    = block.number;
50     }
51     // ## ERC20 standards ##
52     
53     // Get the total token supply
54     function totalSupply() constant public returns (uint256 thetotalSupply){
55     	return _totalSupply;
56     }
57     // Get the account balance of another account with address _queryaddress
58     function balanceOf(address _queryaddress) constant public returns (uint256 balance){
59     	return balances[_queryaddress];
60     }
61  	
62     // Send _value amount of tokens to address _to
63     function transfer(address _to, uint256 _value) public returns (bool success){
64     	require(
65     		balances[msg.sender] >= _value
66     		&& _value > 0);
67     	balances[msg.sender] = balances[msg.sender].sub(_value);
68     	balances[_to]      	 = balances[_to].add(_value);
69     	Transfer(msg.sender, _to,_value);
70     	return true;
71     }
72     // Send _value amount of tokens from address _from to address _to
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
74     	require(
75     		allowedToSpend[_from][msg.sender] >= _value
76     		&& balances[_from] >= _value
77     		&& _value > 0);
78     	balances[_from] = balances[_from].sub(_value);
79     	balances[_to]   = balances[_to].add(_value);
80     	allowedToSpend[_from][msg.sender] = allowedToSpend[_from][msg.sender].sub(_value);
81     	Transfer(_from, _to, _value);
82     	return true;
83     }
84     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
85     // If this function is called again it overwrites the current allowance with _value.
86     // this function is required for some DEX functionality
87     function approve(address _spender, uint256 _value) public returns (bool success){
88     	allowedToSpend[msg.sender][_spender] = _value;
89     	Approval(msg.sender, _spender, _value);
90     	return true;
91     }
92     // Returns the amount which _spender is still allowed to withdraw from _owner
93     function allowance(address _owner, address _spender) constant public returns (uint256 remaining){
94     	return allowedToSpend[_owner][_spender];
95     }
96     // Triggered when tokens are transferred.
97     event Transfer(address indexed _from, address indexed _to, uint256 _value);
98     // Triggered whenever approve(address _spender, uint256 _value) is called.
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100     
101     // ## ERC20 standards end ##
102     // ## Custom functions ###
103     function() public payable {
104     	require(msg.value > 0);
105     	tokens 		 = msg.value.mul(rate);
106     	currentBlock = block.number;
107     	if(rate > 1 && currentBlock.sub(lastblock) > 3000){
108     		rate = rate.sub(1);
109     		RateChange(rate);
110     		lastblock 		 = currentBlock;
111     	} 
112     	balances[msg.sender] = balances[msg.sender].add(tokens);
113     	_totalSupplyLeft 	 = _totalSupplyLeft.sub(tokens);
114     	contract_owner.transfer(msg.value);
115     	MoneyTransfered(contract_owner,msg.value);
116     	
117     }
118     function shutThatShitDown() public {
119     	require(msg.sender == contract_owner);
120     	selfdestruct(contract_owner);
121     }
122     
123     // 
124     event RateChange(uint256 _rate);
125     // 
126     event MoneyTransfered(address indexed _owner, uint256 _msgvalue);
127     
128 }