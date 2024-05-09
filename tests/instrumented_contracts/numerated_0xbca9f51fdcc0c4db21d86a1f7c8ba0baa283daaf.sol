1 pragma solidity 0.4.21;
2 
3 // Declaring the API of external functions.
4 contract IJNBToken {
5     function acceptOwnership() public;
6     function transfer(address _to, uint _value) public returns(bool);
7 }
8 
9 
10 contract Ownable {
11     address public owner; 
12     address public newOwner; 
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); 
15 
16     /**
17     * @dev Throws if called by any account other than the owner.
18     */
19     modifier onlyOwner() {
20         require(msg.sender == owner); // Requiring that the function caller must be owner.
21         _;
22     }
23 
24     /**
25     * @dev Allows the current owner to transfer control of the contract to a newOwner.
26     * @param _newOwner The address to transfer ownership to.
27     */
28     function transferOwnership(address _newOwner) public onlyOwner {
29         require(address(0) != _newOwner); 
30         newOwner = _newOwner; // Setting the newOwner.
31     }
32     
33     function acceptOwnership() public {
34         require(msg.sender == newOwner); // Requiring that the caller must be newOwner.
35         emit OwnershipTransferred(owner, msg.sender); // Triggering the OwnershipTransferred event.
36         owner = msg.sender;
37         newOwner = address(0); // Resetting the newOwner as zero.
38     }
39 }
40 
41 
42 contract JNBOwner is Ownable{
43 
44     address public constant addr = 0x21D5A14e625d767Ce6b7A167491C2d18e0785fDa; // The address of JNB Token.
45      
46 	function JNBOwner(address _owner) public { 
47 		owner = _owner; // The constructor sets owner as '_owner'.
48 	}
49 
50     function acceptJNBOwner() public{
51         IJNBToken(addr).acceptOwnership(); // Calling external function to compelete 'transferOwnership' operation.
52     }
53     
54     function withdrawJNB(uint256 _amount) onlyOwner public{
55         require(IJNBToken(addr).transfer(owner,_amount)); // Requiring the return value of callling external function 
56     }
57 
58 }