1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control 
4  * functions, this simplifies the implementation of "user permissions". 
5  */
6 contract Ownable {
7   address public owner;
8 
9 
10   /** 
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner. 
21    */
22   modifier onlyOwner() {
23     if (msg.sender != owner) {
24       throw;
25     }
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to. 
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 contract ERC20Basic {
42   uint public totalSupply;
43   function balanceOf(address who) constant returns (uint);
44   function transfer(address to, uint value);
45   event Transfer(address indexed from, address indexed to, uint value);
46 }
47 
48 contract ERC20 is ERC20Basic {
49   function allowance(address owner, address spender) constant returns (uint);
50   function transferFrom(address from, address to, uint value);
51   function approve(address spender, uint value);
52   event Approval(address indexed owner, address indexed spender, uint value);
53 }
54 
55 
56 contract Airdropper is Ownable {
57 
58     function multisend(address _tokenAddr, address[] dests, uint256 value)
59     onlyOwner
60     returns (uint256) {
61         uint256 i = 0;
62         while (i < dests.length) {
63            ERC20(_tokenAddr).transfer(dests[i], value);
64            i += 1;
65         }
66         return(i);
67     }
68 }