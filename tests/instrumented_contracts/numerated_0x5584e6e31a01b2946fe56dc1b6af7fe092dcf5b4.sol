1 pragma solidity ^0.4.24;
2 
3 /**
4 * POWERED BY
5 * ╦   ╔═╗ ╦═╗ ╔╦╗ ╦   ╔═╗ ╔═╗ ╔═╗      ╔╦╗ ╔═╗ ╔═╗ ╔╦╗
6 * ║   ║ ║ ╠╦╝  ║║ ║   ║╣  ╚═╗ ╚═╗       ║  ║╣  ╠═╣ ║║║
7 * ╩═╝ ╚═╝ ╩╚═ ═╩╝ ╩═╝ ╚═╝ ╚═╝ ╚═╝       ╩  ╚═╝ ╩ ╩ ╩ ╩
8 * game at https://lordless.games
9 * code at https://github.com/lordlessio
10 */
11 
12 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
13 
14 /**
15  * @title Ownable
16  * @dev The Ownable contract has an owner address, and provides basic authorization control
17  * functions, this simplifies the implementation of "user permissions".
18  */
19 contract Ownable {
20   address public owner;
21 
22 
23   event OwnershipRenounced(address indexed previousOwner);
24   event OwnershipTransferred(
25     address indexed previousOwner,
26     address indexed newOwner
27   );
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   constructor() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to relinquish control of the contract.
48    * @notice Renouncing to ownership will leave the contract without an owner.
49    * It will not be possible to call the functions with the `onlyOwner`
50    * modifier anymore.
51    */
52   function renounceOwnership() public onlyOwner {
53     emit OwnershipRenounced(owner);
54     owner = address(0);
55   }
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address _newOwner) public onlyOwner {
62     _transferOwnership(_newOwner);
63   }
64 
65   /**
66    * @dev Transfers control of the contract to a newOwner.
67    * @param _newOwner The address to transfer ownership to.
68    */
69   function _transferOwnership(address _newOwner) internal {
70     require(_newOwner != address(0));
71     emit OwnershipTransferred(owner, _newOwner);
72     owner = _newOwner;
73   }
74 }
75 
76 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * See https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   function totalSupply() public view returns (uint256);
85   function balanceOf(address _who) public view returns (uint256);
86   function transfer(address _to, uint256 _value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
91 
92 /**
93  * @title ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/20
95  */
96 contract ERC20 is ERC20Basic {
97   function allowance(address _owner, address _spender)
98     public view returns (uint256);
99 
100   function transferFrom(address _from, address _to, uint256 _value)
101     public returns (bool);
102 
103   function approve(address _spender, uint256 _value) public returns (bool);
104   event Approval(
105     address indexed owner,
106     address indexed spender,
107     uint256 value
108   );
109 }
110 
111 // File: contracts/Airdrop.sol
112 
113 contract Airdrop is Ownable {
114   /**
115    * @dev daAirdrop to address
116    * @param _tokenAddr address the erc20 token address
117    * @param dests address[] addresses to airdrop
118    * @param values uint256[] value(in wei) to airdrop
119    */
120   function doAirdrop(string desc, address _tokenAddr, address[] dests, uint256[] values) onlyOwner public
121     returns (uint256) {
122     uint256 i = 0;
123     while (i < dests.length) {
124       ERC20(_tokenAddr).transferFrom(msg.sender, dests[i], values[i]);
125       i += 1;
126     }
127     return(i);
128   }
129 }