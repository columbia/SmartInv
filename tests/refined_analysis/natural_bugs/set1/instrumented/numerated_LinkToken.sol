1 pragma solidity ^0.4.11;
2 
3 
4 import './ERC677Token.sol';
5 import './token/linkStandardToken.sol';
6 
7 
8 contract LinkToken is linkStandardToken, ERC677Token {
9 
10   uint public constant totalSupply = 10**27;
11   string public constant name = 'ChainLink Token';
12   uint8 public constant decimals = 18;
13   string public constant symbol = 'LINK';
14 
15   function LinkToken()
16     public
17   {
18     balances[msg.sender] = totalSupply;
19   }
20 
21   /**
22   * @dev transfer token to a specified address with additional data if the recipient is a contract.
23   * @param _to The address to transfer to.
24   * @param _value The amount to be transferred.
25   * @param _data The extra data to be passed to the receiving contract.
26   */
27   function transferAndCall(address _to, uint _value, bytes _data)
28     public
29     validRecipient(_to)
30     returns (bool success)
31   {
32     return super.transferAndCall(_to, _value, _data);
33   }
34 
35   /**
36   * @dev transfer token to a specified address.
37   * @param _to The address to transfer to.
38   * @param _value The amount to be transferred.
39   */
40   function transfer(address _to, uint _value)
41     public
42     validRecipient(_to)
43     returns (bool success)
44   {
45     return super.transfer(_to, _value);
46   }
47 
48   /**
49    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
50    * @param _spender The address which will spend the funds.
51    * @param _value The amount of tokens to be spent.
52    */
53   function approve(address _spender, uint256 _value)
54     public
55     validRecipient(_spender)
56     returns (bool)
57   {
58     return super.approve(_spender,  _value);
59   }
60 
61   /**
62    * @dev Transfer tokens from one address to another
63    * @param _from address The address which you want to send tokens from
64    * @param _to address The address which you want to transfer to
65    * @param _value uint256 the amount of tokens to be transferred
66    */
67   function transferFrom(address _from, address _to, uint256 _value)
68     public
69     validRecipient(_to)
70     returns (bool)
71   {
72     return super.transferFrom(_from, _to, _value);
73   }
74 
75 
76   // MODIFIERS
77 
78   modifier validRecipient(address _recipient) {
79     require(_recipient != address(0) && _recipient != address(this));
80     _;
81   }
82 
83 }
