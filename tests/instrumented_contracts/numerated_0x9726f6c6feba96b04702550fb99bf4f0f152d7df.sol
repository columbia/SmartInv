1 pragma solidity ^0.4.24;
2 contract ERC20Basic {
3     uint256 public totalSupply;
4     function balanceOf(address who) public constant returns (uint256);
5     function transfer(address to, uint256 value) public returns (bool);
6     event Transfer(address indexed from, address indexed to, uint256 value);
7 }
8 
9 contract Ownable {
10   address public owner;
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     emit OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44   /**
45    * @dev Allows the current owner to relinquish control of the contract.
46    */
47   function renounceOwnership() public onlyOwner {
48     emit OwnershipRenounced(owner);
49     owner = address(0);
50   }
51 }
52 
53 contract Airdrop is Ownable {
54 
55     ERC20Basic token;
56 
57     constructor(address tokenAddress) public {
58         token = ERC20Basic(tokenAddress);
59     }
60 
61     function sendWinnings(address[] winners, uint256[] amounts) public onlyOwner {
62         require(winners.length == amounts.length,"The number of winners must match the number of amounts");
63         require(winners.length <= 64);
64         for (uint i = 0; i < winners.length; i++) {
65             token.transfer(winners[i], amounts[i]);
66         }
67     }
68 
69     function withdraw() public onlyOwner {
70         uint256 currentSupply = token.balanceOf(address(this));
71         token.transfer(owner, currentSupply);
72     }
73 
74 }