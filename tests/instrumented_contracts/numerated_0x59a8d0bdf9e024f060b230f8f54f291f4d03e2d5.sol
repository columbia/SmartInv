1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7   uint256 public totalSupply;
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
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
23   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25 
26   /**
27    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28    * account.
29    */
30   function Ownable() public {
31     owner = msg.sender;
32   }
33 
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address newOwner) public onlyOwner {
49     require(newOwner != address(0));
50     OwnershipTransferred(owner, newOwner);
51     owner = newOwner;
52   }
53 
54 }
55 
56 
57 contract CHXSwap is Ownable {
58     event AddressMapped(address indexed ethAddress, string chxAddress);
59     event AddressMappingRemoved(address indexed ethAddress, string chxAddress);
60 
61     mapping (address => string) public mappedAddresses;
62 
63     function CHXSwap()
64         public
65     {
66     }
67 
68     function mapAddress(string _chxAddress)
69         external
70     {
71         address ethAddress = msg.sender;
72         require(bytes(mappedAddresses[ethAddress]).length == 0);
73         mappedAddresses[ethAddress] = _chxAddress;
74         AddressMapped(ethAddress, _chxAddress);
75     }
76 
77     function removeMappedAddress(address _ethAddress)
78         external
79         onlyOwner
80     {
81         require(bytes(mappedAddresses[_ethAddress]).length != 0);
82         string memory chxAddress = mappedAddresses[_ethAddress];
83         delete mappedAddresses[_ethAddress];
84         AddressMappingRemoved(_ethAddress, chxAddress);
85     }
86 
87     // Enable recovery of ether sent by mistake to this contract's address.
88     function drainStrayEther(uint _amount)
89         external
90         onlyOwner
91         returns (bool)
92     {
93         owner.transfer(_amount);
94         return true;
95     }
96 
97     // Enable recovery of any ERC20 compatible token sent by mistake to this contract's address.
98     function drainStrayTokens(ERC20Basic _token, uint _amount)
99         external
100         onlyOwner
101         returns (bool)
102     {
103         return _token.transfer(owner, _amount);
104     }
105 }