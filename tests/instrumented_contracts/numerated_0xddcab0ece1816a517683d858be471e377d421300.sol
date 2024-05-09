1 contract Ownable {
2   address public owner;
3 
4   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
5 
6   function Ownable() public {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     require(msg.sender == owner);
12     _;
13   }
14 
15   function transferOwnership(address newOwner) public onlyOwner {
16     require(newOwner != address(0));
17     OwnershipTransferred(owner, newOwner);
18     owner = newOwner;
19   }
20 
21 }
22 
23 contract ERC721 {
24     function implementsERC721() public pure returns (bool);
25     function totalSupply() public view returns (uint256 total);
26     function balanceOf(address _owner) public view returns (uint256 balance);
27     function ownerOf(uint256 _tokenId) public view returns (address owner);
28     function approve(address _to, uint256 _tokenId) public;
29     function transferFrom(address _from, address _to, uint256 _tokenId) public;
30     function transfer(address _to, uint256 _tokenId) public;
31     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
32     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
33 }
34 
35 contract SampleStorage is Ownable {
36     
37     struct Sample {
38         string ipfsHash;
39         uint rarity;
40     }
41     
42     mapping (uint32 => Sample) public sampleTypes;
43     
44     uint32 public numOfSampleTypes;
45     
46     uint32 public numOfCommon;
47     uint32 public numOfRare;
48     uint32 public numOfLegendary;
49 
50     // The mythical sample is a type common that appears only once in a 1000
51     function addNewSampleType(string _ipfsHash, uint _rarityType) public onlyOwner {
52         
53         if (_rarityType == 0) {
54             numOfCommon++;
55         } else if (_rarityType == 1) {
56             numOfRare++;
57         } else if(_rarityType == 2) {
58             numOfLegendary++;
59         } else if(_rarityType == 3) {
60             numOfCommon++;
61         }
62         
63         sampleTypes[numOfSampleTypes] = Sample({
64            ipfsHash: _ipfsHash,
65            rarity: _rarityType
66         });
67         
68         numOfSampleTypes++;
69     }
70     
71     function getType(uint _randomNum) public view returns (uint32) {
72         uint32 range = 0;
73         
74         if (_randomNum > 0 && _randomNum < 600) {
75             range = 600 / numOfCommon;
76             return uint32(_randomNum) / range;
77             
78         } else if(_randomNum >= 600 && _randomNum < 900) {
79             range = 300 / numOfRare;
80             return uint32(_randomNum) / range;
81         } else {
82             range = 100 / numOfLegendary;
83             return uint32(_randomNum) / range;
84         }
85     }
86     
87 }