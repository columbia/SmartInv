1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title ERC20
5  * @dev ERC20 interface
6  */
7 contract ERC20 {
8     function balanceOf(address who) public view returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     function allowance(address owner, address spender) public view returns (uint256);
11     function transferFrom(address from, address to, uint256 value) public returns (bool);
12     function approve(address spender, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 /**
62  * @title claim accidentally sent tokens
63  */
64 contract HasNoTokens is Ownable {
65     event ExtractedTokens(address indexed _token, address indexed _claimer, uint _amount);
66 
67     /// @notice This method can be used to extract mistakenly
68     ///  sent tokens to this contract.
69     /// @param _token The address of the token contract that you want to recover
70     ///  set to 0 in case you want to extract ether.
71     /// @param _claimer Address that tokens will be send to
72     function extractTokens(address _token, address _claimer) onlyOwner public {
73         if (_token == 0x0) {
74             _claimer.transfer(this.balance);
75             return;
76         }
77 
78         ERC20 token = ERC20(_token);
79         uint balance = token.balanceOf(this);
80         token.transfer(_claimer, balance);
81         ExtractedTokens(_token, _claimer, balance);
82     }
83 }
84 
85 
86 /**
87  * @title claim accidentally sent tokens
88  */
89 contract BountyDistribute is HasNoTokens {
90     /// @notice distribute tokens
91     function distributeTokens(address _token, address[] _to, uint256[] _value) external onlyOwner {
92         require(_to.length == _value.length);
93 
94         ERC20 token = ERC20(_token);
95 
96         for (uint256 i = 0; i < _to.length; i++) {
97             token.transfer(_to[i], _value[i]);
98         }
99     }
100 }