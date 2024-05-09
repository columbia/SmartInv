1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   constructor() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     emit OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 contract WhitepaperVersioning {
39     mapping (address => Whitepaper[]) private whitepapers;
40     mapping (address => address) private authors;
41     event Post(address indexed _contract, uint256 indexed _version, string _ipfsHash, address _author);
42 
43     struct Whitepaper {
44         uint256 version;
45         string ipfsHash;
46     }
47 
48     /**
49      * @dev Constructor
50      * @dev Doing nothing.
51      */
52     constructor () public {}
53 
54     /**
55      * @dev Function to post a new whitepaper
56      * @param _version uint256 Version number in integer
57      * @param _ipfsHash string IPFS hash of the posting whitepaper
58      * @return status bool
59      */
60     function pushWhitepaper (Ownable _contract, uint256 _version, string _ipfsHash) public returns (bool) {
61         uint256 num = whitepapers[_contract].length;
62         if(num == 0){
63             // If the posting whitepaper is the initial, only the target contract owner can post.
64             require(_contract.owner() == msg.sender);
65             authors[_contract] = msg.sender;
66         }else{
67             // Check if the initial version whitepaper's author is the msg.sender
68             require(authors[_contract] == msg.sender);
69             // Check if the version is greater than the previous version
70             require(whitepapers[_contract][num-1].version < _version);
71         }
72     
73         whitepapers[_contract].push(Whitepaper(_version, _ipfsHash));
74         emit Post(_contract, _version, _ipfsHash, msg.sender);
75         return true;
76     }
77   
78     /**
79      * @dev Look up whitepaper at the specified index
80      * @param _contract address Target contract address associated with a whitepaper
81      * @param _index uint256 Index number of whitepapers associated with the specified contract address
82      * @return version uint8 Version number in integer
83      * @return ipfsHash string IPFS hash of the whitepaper
84      * @return author address Address of an account who posted the whitepaper
85      */
86     function getWhitepaperAt (address _contract, uint256 _index) public view returns (
87         uint256 version,
88         string ipfsHash,
89         address author
90     ) {
91         return (
92             whitepapers[_contract][_index].version,
93             whitepapers[_contract][_index].ipfsHash,
94             authors[_contract]
95         );
96     }
97     
98     /**
99      * @dev Look up whitepaper at the specified index
100      * @param _contract address Target contract address associated with a whitepaper
101      * @return version uint8 Version number in integer
102      * @return ipfsHash string IPFS hash of the whitepaper
103      * @return author address Address of an account who posted the whitepaper
104      */
105     function getLatestWhitepaper (address _contract) public view returns (
106         uint256 version,
107         string ipfsHash,
108         address author
109     ) {
110         uint256 latest = whitepapers[_contract].length - 1;
111         return getWhitepaperAt(_contract, latest);
112     }
113 }