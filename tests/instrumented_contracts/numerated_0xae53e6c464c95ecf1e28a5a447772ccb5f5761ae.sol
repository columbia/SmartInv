1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 Ownable
5  * @dev ERC20 interface
6  * @author Comps Pte. Ltd.
7  */
8 contract ERC20 {
9   address public owner;
10   string public name;
11   string public symbol;
12   uint256 public decimals;
13   uint256 public totalSupply;
14 
15   function totalSupply() public view returns (uint256);
16   function balanceOf(address _who) public view returns (uint256);
17   function transfer(address _to, uint256 _value) public returns (bool);
18   function approve(address _spender, uint256 _value) public returns (bool);
19   function allowance(address _owner, address _spender) public view returns (uint256);
20   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
21   event Transfer(address indexed from, address indexed to, uint256 value);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title  ERC20 Meta Info
27  * @dev    Mata data storage for ERC20 compatible tokens
28  */
29 contract ERC20MetaInfo {
30   address public owner;
31   mapping (address => mapping (string => string)) keyValues;
32 
33   // constructor
34   constructor() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev   setKeyValue Assign (key, value) pair to a token
40    * @param _token      ERC20 compatible token contract's address
41    * @param _key        Key in string
42    * @param _value      Value in string
43    */
44   function setKeyValue(ERC20 _token, string _key, string _value) public returns (bool) {
45     // If a value is empty, anybody can assign a pair of (key, value)
46     // Otherwise, only token contract's "owner" (if the token contract is Ownable),
47     // or ERC20MetaInfo contract owner can assign/update a value
48     require(bytes(keyValues[_token][_key]).length == 0 || owner == msg.sender || _token.owner() == msg.sender);
49     keyValues[_token][_key] = _value;
50     return true;
51   }
52 
53   /**
54    * @dev   getKeyValue Get value correspoinding to a key
55    * @param _token      ERC20 compatible token contract's address
56    * @param _key        Specify a key in string
57    */
58   function getKeyValue(address _token, string _key) public view returns (string _value) {
59     return keyValues[_token][_key];
60   }
61 }