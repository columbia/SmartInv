1 pragma solidity ^0.4.18;
2  
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10  
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26  
27 }
28 
29  
30 interface IERC20 {
31   function totalSupply() public constant returns (uint256 );
32   function balanceOf(address _owner) public constant returns (uint256 );
33   function transfer(address _to, uint256 _value) public returns (bool );
34   function decimals() public constant returns (uint8 decimals);
35   //function transferFrom(address _from, address _to, uint256 _value) public returns (bool );
36   //function approve(address _spender, uint256 _value) public returns (bool );
37   //function allowance(address _owner, address _spender) public constant returns (uint256 );
38   //event Transfer(address indexed _from, address indexed _to, uint256 _value);
39   //event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41  
42 contract Airdropper is Ownable {
43     
44     function batchTransfer(address[] _recipients, uint[] _values, address _tokenAddress) onlyOwner public returns (bool) {
45         require( _recipients.length > 0 && _recipients.length == _values.length);
46  
47         IERC20 token = IERC20(_tokenAddress);
48         // uint8 decimals = token.decimals();
49 
50         // uint total = 0;
51         // for(uint i = 0; i < _values.length; i++){
52         //     total += _values[i];
53         // }
54         // require(total <= token.balanceOf(this));
55         
56         for(uint j = 0; j < _recipients.length; j++){
57             token.transfer(_recipients[j], _values[j]  );
58         }
59  
60         return true;
61     }
62  
63      function withdrawalToken(address _tokenAddress) onlyOwner public { 
64         IERC20 token = IERC20(_tokenAddress);
65         require(token.transfer(owner, token.balanceOf(this)));
66     }
67 
68 }