1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 contract NotCoin is ERC20 {
29   uint constant MAX_UINT = 2**256 - 1;
30   string public name;
31   string public symbol;
32   uint8 public decimals;
33 
34   function NotCoin(string _name, string _symbol, uint8 _decimals) public {
35     name = _name;
36     symbol = _symbol;
37     decimals = _decimals;
38   }
39 
40 
41   function totalSupply() public view returns (uint) {
42     return MAX_UINT;
43   }
44 
45   function balanceOf(address _owner) public view returns (uint256 balance) {
46     return MAX_UINT;
47   }
48 
49   function transfer(address _to, uint _value) public returns (bool)  {
50     Transfer(msg.sender, _to, _value);
51     return true;
52   }
53 
54   function approve(address _spender, uint256 _value) public returns (bool) {
55     Approval(msg.sender, _spender, _value);
56     return true;
57   }
58 
59   function allowance(address _owner, address _spender) public view returns (uint256) {
60     return MAX_UINT;
61   }
62 
63   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
64     Transfer(_from, _to, _value);
65     return true;
66   }
67 
68 }