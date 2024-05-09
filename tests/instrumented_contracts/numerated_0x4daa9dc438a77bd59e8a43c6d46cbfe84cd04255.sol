1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     /**
12     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13     * account.
14     */
15     function Ownable() public {
16         owner = msg.sender;
17     }
18 
19     /**
20     * @dev Throws if called by any account other than the owner.
21     */
22     modifier onlyOwner() {
23         require(msg.sender == owner);
24         _;
25     }
26 
27     /**
28     * @dev Allows the current owner to transfer control of the contract to a newOwner.
29     * @param newOwner The address to transfer ownership to.
30     */
31     function transferOwnership(address newOwner) public onlyOwner {
32         if (newOwner != address(0)) {
33             owner = newOwner;
34         }
35     }
36 }
37 
38 
39 contract BattleToken is Ownable {
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 
43     uint256 constant private MAX_UINT256 = 2**256 - 1;
44     mapping (address => uint256) public balances;
45     mapping (address => mapping (address => uint256)) public allowed;
46     uint256 public totalSupply;
47     string public name = "https://cryptobots.me/cbtb - CryptoBotsBattle";
48     uint8 public decimals = 0;
49     string public symbol = "CBTB";
50 
51     address public fights;
52 
53     function setFightsAddress(address _fights) public onlyOwner {
54         fights = _fights;
55     }
56 
57     function create(uint _amount) public onlyOwner {
58         balances[msg.sender] = safeAdd(balances[msg.sender], _amount);
59         totalSupply = safeAdd(totalSupply, _amount);
60     }
61 
62     function transfer(address _to, uint256 _value) public returns (bool success) {
63         balances[msg.sender] = safeSub(balances[msg.sender], _value);
64         balances[_to] = safeAdd(balances[_to], _value);
65         Transfer(msg.sender, _to, _value);
66         return true;
67     }
68 
69     function batchTransfer(address[] _to, uint _value) public {
70         balances[msg.sender] = safeSub(
71             balances[msg.sender], _to.length * _value
72         );
73         for (uint i = 0; i < _to.length; i++) {
74             balances[_to[i]] = safeAdd(balances[_to[i]], _value);
75             Transfer(msg.sender, _to[i], _value);
76         }
77     }
78 
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
80         balances[_to] = safeAdd(balances[_to], _value);
81         balances[_from] = safeSub(balances[_from], _value);
82         if (_to != fights) {
83             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
84         }
85         Transfer(_from, _to, _value);
86         return true;
87     }
88 
89     function balanceOf(address _owner) public view returns (uint256 balance) {
90         return balances[_owner];
91     }
92 
93     function approve(address _spender, uint256 _value) public returns (bool success) {
94         allowed[msg.sender][_spender] = _value;
95         Approval(msg.sender, _spender, _value);
96         return true;
97     }
98 
99     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
100         return allowed[_owner][_spender];
101     }
102 
103     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         assert(c >= a);
106         return c;
107     }
108 
109     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
110         assert(b <= a);
111         return a - b;
112     }
113 }