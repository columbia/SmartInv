1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   uint8 public decimals;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   function transferFrom(address _from, address _to, uint _value) returns (bool success);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15   
16 }
17 
18 
19 /**
20  * @title Ownable
21  * @dev The Ownable contract has an owner address, and provides basic authorization control
22  * functions, this simplifies the implementation of "user permissions".
23  */
24 contract Ownable {
25   address public owner;
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   function Ownable() {
32     owner = msg.sender;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address newOwner) onlyOwner public {
48     require(newOwner != address(0));
49     OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 
55 contract Exchange is Ownable {
56   mapping (address => bool) public supportedTokens;
57   event ExchangeEvent(address tokenToSell, address tokenToBuy, uint256 value);
58   
59   function setSupportedTokens(address tokenAddress, bool op) onlyOwner public {
60     supportedTokens[tokenAddress] = op;
61   }
62   
63     /**
64    *  exchange ERC20 tokens with 1:1.
65    */
66   function exchangeERC20(address _tokenToSell, address _tokenToBuy, uint256 _value) {
67     require(supportedTokens[_tokenToSell]);
68     require(supportedTokens[_tokenToBuy]);
69     require(_tokenToSell != _tokenToBuy);
70     
71     ERC20Basic tokenToSell = ERC20Basic(_tokenToSell);
72     ERC20Basic tokenToBuy = ERC20Basic(_tokenToBuy);
73 
74     require(_value > 0 && tokenToBuy.balanceOf(address(this)) >= _value);
75 
76     if (!tokenToSell.transferFrom(msg.sender, address(this), _value)) throw;
77     tokenToBuy.transfer(msg.sender, _value);
78   
79     ExchangeEvent(_tokenToSell,_tokenToBuy,_value);
80   }
81 }