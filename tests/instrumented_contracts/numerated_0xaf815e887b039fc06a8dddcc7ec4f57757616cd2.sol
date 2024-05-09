1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20Basic {
9   uint public totalSupply;
10   function balanceOf(address _owner) public constant returns (uint balance);
11   function transfer(address _to, uint _value) public returns (bool success);
12   function allowance(address _owner, address _spender) public constant returns (uint remaining);
13   function approve(address _spender, uint _value) public returns (bool success);
14 
15   event Transfer(address indexed _from, address indexed _to, uint _value);
16   event Approval(address indexed _owner, address indexed _spender, uint _value);
17 }
18 
19 
20 /**
21  * @title Standard ERC20 token
22  */
23 contract StandardToken is ERC20Basic {
24 
25     mapping (address => uint256) balances;
26     mapping (address => mapping (address => uint256)) allowed;
27 
28    /**
29   * @dev transfer token for a specified address
30   * @param _to The address to transfer to.
31   * @param _value The amount to be transferred.
32   */
33     function transfer(address _to, uint256 _value) public returns (bool success) {
34 	    require((_value > 0) && (balances[msg.sender] >= _value));
35 	    balances[msg.sender] -= _value;
36     	balances[_to] += _value;
37     	Transfer(msg.sender, _to, _value);
38     	return true;
39     }
40 
41   /**
42   * @dev Gets the balance of the specified address.
43   * @param _owner The address to query the the balance of.
44   * @return An uint256 representing the amount owned by the passed address.
45   */
46     function balanceOf(address _owner) public constant returns (uint256 balance) {
47         return balances[_owner];
48     }
49 
50   /**
51    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
52    * @param _spender The address which will spend the funds.
53    * @param _value The amount of tokens to be spent.
54    */
55     function approve(address _spender, uint256 _value) public returns (bool success) {
56         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
57     	allowed[msg.sender][_spender] = _value;
58     	Approval(msg.sender, _spender, _value);
59     	return true;
60     }
61 
62    /**
63    * @dev Function to check the amount of tokens that an owner allowed to a spender.
64    * @param _owner address The address which owns the funds.
65    * @param _spender address The address which will spend the funds.
66    * @return A uint256 specifing the amount of tokens still avaible for the spender.
67    */
68     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
69       return allowed[_owner][_spender];
70     }
71 
72 }
73 
74 /**
75  * @title OneGameToken
76  */
77 contract OneGameToken is StandardToken {
78     string public constant name = "One Game Token";
79     string public constant symbol = "OGT";
80     uint public constant decimals = 18;
81 
82     address public target;
83 
84     function OneGameToken(address _target) public {
85         target = _target;
86         totalSupply = 1*10**28;
87         balances[target] = totalSupply;
88     }
89 }