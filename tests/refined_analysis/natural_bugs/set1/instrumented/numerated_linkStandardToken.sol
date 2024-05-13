1 pragma solidity ^0.4.11;
2 
3 
4 import './linkBasicToken.sol';
5 import './linkERC20.sol';
6 
7 
8 /**
9  * @title Standard ERC20 token
10  *
11  * @dev Implementation of the basic standard token.
12  * @dev https://github.com/ethereum/EIPs/issues/20
13  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
14  */
15 contract linkStandardToken is linkERC20, linkBasicToken {
16 
17   mapping (address => mapping (address => uint256)) allowed;
18 
19 
20   /**
21    * @dev Transfer tokens from one address to another
22    * @param _from address The address which you want to send tokens from
23    * @param _to address The address which you want to transfer to
24    * @param _value uint256 the amount of tokens to be transferred
25    */
26   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
27     var _allowance = allowed[_from][msg.sender];
28 
29     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
30     // require (_value <= _allowance);
31 
32     balances[_from] = balances[_from].sub(_value);
33     balances[_to] = balances[_to].add(_value);
34     allowed[_from][msg.sender] = _allowance.sub(_value);
35     Transfer(_from, _to, _value);
36     return true;
37   }
38 
39   /**
40    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
41    * @param _spender The address which will spend the funds.
42    * @param _value The amount of tokens to be spent.
43    */
44   function approve(address _spender, uint256 _value) returns (bool) {
45     allowed[msg.sender][_spender] = _value;
46     Approval(msg.sender, _spender, _value);
47     return true;
48   }
49 
50   /**
51    * @dev Function to check the amount of tokens that an owner allowed to a spender.
52    * @param _owner address The address which owns the funds.
53    * @param _spender address The address which will spend the funds.
54    * @return A uint256 specifying the amount of tokens still available for the spender.
55    */
56   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
57     return allowed[_owner][_spender];
58   }
59   
60     /*
61    * approve should be called when allowed[_spender] == 0. To increment
62    * allowed value is better to use this function to avoid 2 calls (and wait until 
63    * the first transaction is mined)
64    * From MonolithDAO Token.sol
65    */
66   function increaseApproval (address _spender, uint _addedValue) 
67     returns (bool success) {
68     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
69     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
70     return true;
71   }
72 
73   function decreaseApproval (address _spender, uint _subtractedValue) 
74     returns (bool success) {
75     uint oldValue = allowed[msg.sender][_spender];
76     if (_subtractedValue > oldValue) {
77       allowed[msg.sender][_spender] = 0;
78     } else {
79       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
80     }
81     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
82     return true;
83   }
84 
85 }
