1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 contract ERC20 {
68     function totalSupply() public view returns (uint256);
69     function balanceOf(address who) public view returns (uint256);
70     function transfer(address to, uint256 value) public returns (bool);
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 
75 contract BountyClaim is Ownable {
76     mapping (address => uint256) allowance;
77     address _tokenAddress = 0x2A22e5cCA00a3D63308fa39f29202eB1b39eEf52;
78 
79     constructor() public {
80         allowance[0xF4eb8c7473CFC2EED0F448DCdBA7C8f7357E57A9] = 5000000000000000000;
81         allowance[0xfcA406118f56912A042D9898Bf0a12241C720c9b] = 10000000000000000000;
82     }
83 
84     function() public payable {
85         require(allowance[msg.sender] > 0);
86         ERC20(_tokenAddress).transfer(msg.sender, allowance[msg.sender]);
87         allowance[msg.sender] = 0;
88     }
89 
90     function withdraw(uint256 amount) onlyOwner {
91         ERC20(_tokenAddress).transfer(msg.sender, amount);
92     }
93 }