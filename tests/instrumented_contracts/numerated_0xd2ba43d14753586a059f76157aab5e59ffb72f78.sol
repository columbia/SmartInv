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
23 contract SampleStorage is Ownable {
24     
25     struct Sample {
26         string ipfsHash;
27         uint rarity;
28     }
29     
30     mapping (uint => Sample) sampleTypes;
31     
32     uint public numOfSampleTypes;
33     
34     uint public numOfCommon;
35     uint public numOfRare;
36     uint public numOfLegendary;
37     uint public numOfMythical;
38     
39     function addNewSampleType(string _ipfsHash, uint _rarityType) public onlyOwner {
40         
41         if (_rarityType == 0) {
42             numOfCommon++;
43         } else if (_rarityType == 1) {
44             numOfRare++;
45         } else if(_rarityType == 2) {
46             numOfLegendary++;
47         } else if(_rarityType == 3) {
48             numOfMythical++;
49         }
50         
51         sampleTypes[numOfSampleTypes] = Sample({
52            ipfsHash: _ipfsHash,
53            rarity: _rarityType
54         });
55         
56         numOfSampleTypes++;
57     }
58     
59     function getType(uint _randomNum) public view returns (uint) {
60         uint range = 0;
61         
62         if (_randomNum > 0 && _randomNum < 600) {
63             range = 600 / numOfCommon;
64             return _randomNum / range;
65             
66         } else if(_randomNum >= 600 && _randomNum < 900) {
67             range = 300 / numOfRare;
68             return _randomNum / range;
69         } else {
70             range = 100 / numOfLegendary;
71             return _randomNum / range;
72         }
73     }
74     
75 }