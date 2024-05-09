1 pragma solidity ^0.4.24;
2 //ERC20
3 contract ERC20Ownable {
4     address public owner;
5 
6     function ERC20Ownable() public{
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14     function transferOwnership(address newOwner) onlyOwner public{
15         if (newOwner != address(0)) {
16             owner = newOwner;
17         }
18     }
19 }
20 contract ERC20 {
21     function transfer(address to, uint256 value) public returns (bool);
22     function balanceOf(address who) public view returns (uint256);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 }
25 
26 contract ERC20Token is ERC20,ERC20Ownable {
27     
28     mapping (address => uint256) balances;
29 	mapping (address => mapping (address => uint256)) allowed;
30 	
31     event Transfer(
32 		address indexed _from,
33 		address indexed _to,
34 		uint256 _value
35 		);
36 
37 	event Approval(
38 		address indexed _owner,
39 		address indexed _spender,
40 		uint256 _value
41 		);
42 		
43 	//Fix for short address attack against ERC20
44 	modifier onlyPayloadSize(uint size) {
45 		assert(msg.data.length == size + 4);
46 		_;
47 	}
48 
49 	function balanceOf(address _owner) constant public returns (uint256) {
50 		return balances[_owner];
51 	}
52 
53 	function transfer(address _to, uint256 _value) onlyPayloadSize(2*32) public returns (bool){
54 		require(balances[msg.sender] >= _value && _value > 0);
55 	    balances[msg.sender] -= _value;
56 	    balances[_to] += _value;
57 	    emit Transfer(msg.sender, _to, _value);
58 	    return true;
59     }
60 
61 	function transferFrom(address _from, address _to, uint256 _value) public {
62 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
63         balances[_to] += _value;
64         balances[_from] -= _value;
65         allowed[_from][msg.sender] -= _value;
66         emit Transfer(_from, _to, _value);
67     }
68 
69 	function approve(address _spender, uint256 _value) public {
70 		allowed[msg.sender][_spender] = _value;
71 		emit Approval(msg.sender, _spender, _value);
72 	}
73 
74     /* Approves and then calls the receiving contract */
75     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
76         allowed[msg.sender][_spender] = _value;
77         emit Approval(msg.sender, _spender, _value);
78         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
79         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
80         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
81         //require(_spender.call(bytes4(keccak256("receiveApproval(address,uint256,address,bytes)")), abi.encode(msg.sender, _value, this, _extraData)));
82         require(_spender.call(abi.encodeWithSelector(bytes4(keccak256("receiveApproval(address,uint256,address,bytes)")),msg.sender, _value, this, _extraData)));
83 
84         return true;
85     }
86     
87 	function allowance(address _owner, address _spender) constant public returns (uint256) {
88 		return allowed[_owner][_spender];
89 	}
90 }
91 
92 contract ERC20StandardToken is ERC20Token {
93 	uint256 public totalSupply;
94 	string public name;
95 	uint256 public decimals;
96 	string public symbol;
97 	bool public mintable;
98 
99 
100     function ERC20StandardToken(address _owner, string _name, string _symbol, uint256 _decimals, uint256 _totalSupply, bool _mintable) public {
101         require(_owner != address(0));
102         owner = _owner;
103 		decimals = _decimals;
104 		symbol = _symbol;
105 		name = _name;
106 		mintable = _mintable;
107         totalSupply = _totalSupply;
108         balances[_owner] = totalSupply;
109     }
110     
111     function mint(uint256 amount) onlyOwner public {
112 		require(mintable);
113 		require(amount >= 0);
114 		balances[msg.sender] += amount;
115 		totalSupply += amount;
116 	}
117 
118     function burn(uint256 _value) onlyOwner public returns (bool) {
119         require(balances[msg.sender] >= _value  && totalSupply >=_value && _value > 0);
120         balances[msg.sender] -= _value;
121         totalSupply -= _value;
122         emit Transfer(msg.sender, 0x0, _value);
123         return true;
124     }
125 }