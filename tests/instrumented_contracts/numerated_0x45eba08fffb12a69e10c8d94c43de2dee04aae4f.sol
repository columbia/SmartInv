1 pragma solidity ^0.4.15;
2 
3 
4 contract Contributor {
5 
6     //=================Variables================
7     bool isInitiated = false;
8 
9     //Addresses
10     address creatorAddress;
11 
12     address contributorAddress;
13 
14     address marketplaceAddress;
15 
16     //State
17     string name;
18 
19     uint creationTime;
20 
21     bool isRepudiated = false;
22 
23     //Publications
24     enum ExtensionType {MODULE, THEME}
25     struct Extension {
26     string name;
27     string version;
28     ExtensionType extType;
29     string moduleKey;
30     }
31 
32     mapping (string => Extension) private publications;
33 
34     //Modifiers
35     modifier onlyBy(address _account) {
36         require(msg.sender == _account);
37         _;
38     }
39 
40     //Events
41     event newExtensionPublished (string _name, string _hash, string _version, ExtensionType _type, string _moduleKey);
42 
43     //=================Transactions================
44     //Constructor
45     function Contributor(string _name, address _contributorAddress, address _marketplaceAddress) {
46         creatorAddress = msg.sender;
47         contributorAddress = _contributorAddress;
48         marketplaceAddress = _marketplaceAddress;
49         creationTime = now;
50         name = _name;
51         isInitiated = true;
52     }
53 
54     //Publish a new extension in structure
55     function publishExtension(string _hash, string _name, string _version, ExtensionType _type, string _moduleKey)
56     onlyBy(creatorAddress) {
57         publications[_hash] = Extension(_name, _version, _type, _moduleKey);
58         newExtensionPublished(_name, _hash, _version, _type, _moduleKey);
59     }
60 
61     //=================Calls================
62     //Check if the contract is initialised
63     function getInitiated() constant returns (bool) {
64         return isInitiated;
65     }
66 
67     //Return basic information about the contract
68     function getInfos() constant returns (address, string, uint) {
69         return (creatorAddress, name, creationTime);
70     }
71 
72     //Return information about a module
73     function getExtensionPublication(string _hash) constant returns (string, string, ExtensionType) {
74         return (publications[_hash].name, publications[_hash].version, publications[_hash].extType);
75     }
76 
77     function haveExtension(string _hash) constant returns (bool) {
78         bool result = true;
79 
80         if (bytes(publications[_hash].name).length == 0) {
81             result = false;
82         }
83         return result;
84     }
85 }