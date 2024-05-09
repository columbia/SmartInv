1 contract ERC20 {
2   function transfer(address _recipient, uint256 _value) public returns (bool success);
3 }
4 
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 
40 }
41 
42 contract Airdrop is Ownable {
43     
44   function distributeBulk(ERC20 token, address[] recipients, uint256[] values) onlyOwner public {
45     for (uint256 i = 0; i < recipients.length; i++) {
46       token.transfer(recipients[i], values[i]);
47     }
48   }
49   
50   function distribute(ERC20 token, address recipient, uint256 value) onlyOwner public {
51       token.transfer(recipient, value);
52   }
53 }