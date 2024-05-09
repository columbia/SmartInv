1 contract Token {
2     uint256 public totalSupply;
3     function balanceOf(address _owner) constant returns (uint256 balance);
4     function transfer(address _to, uint256 _value) returns (bool success);
5     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
6     function approve(address _spender, uint256 _value) returns (bool success);
7     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
8     event Transfer(address indexed _from, address indexed _to, uint256 _value);
9     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
10 }
11 
12 
13 /*  ERC 20 token */
14 contract StandardToken is Token {
15 
16     function transfer(address _to, uint256 _value) returns (bool success) {
17         if (balances[msg.sender] >= _value && _value > 0) {
18             balances[msg.sender] -= _value;
19             balances[_to] += _value;
20             Transfer(msg.sender, _to, _value);
21             return true;
22         } else {
23             return false;
24         }
25     }
26 
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
28         if (balances[_to] + _value < balances[_to]) revert(); // Check for overflows
29         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
30             balances[_to] += _value;
31             balances[_from] -= _value;
32             allowed[_from][msg.sender] -= _value;
33             Transfer(_from, _to, _value);
34             return true;
35         } else {
36             return false;
37         }
38     }
39 
40     function balanceOf(address _owner) constant returns (uint256 balance) {
41         return balances[_owner];
42     }
43 
44     function approve(address _spender, uint256 _value) returns (bool success) {
45         allowed[msg.sender][_spender] = _value;
46         Approval(msg.sender, _spender, _value);
47         return true;
48     }
49 
50     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
51         return allowed[_owner][_spender];
52     }
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;
56 }
57 contract BRM is StandardToken {
58 	string public constant name = "BrahmaOS";
59 	string public constant symbol = "BRM";
60 	uint256 public constant decimals = 18;
61 
62 	uint256 public constant total = 3 * 10**9 * 10**decimals;
63 
64 	function BRM() {
65 		totalSupply = total;
66 		balances[msg.sender] = total;
67 	}
68 	function () public payable {
69 		revert();
70 	}
71 }