1 pragma solidity 0.4.24;
2 
3 
4 contract AccreditationRegistryV1 {
5     address public owner;
6     bool public halted;
7 
8     mapping(bytes32 => mapping(bytes32 => bool)) public accreditations;
9 
10     modifier onlyOwner() {
11         require(
12             msg.sender == owner,
13             "Only the owner can perform this action."
14         );
15         _;
16     }
17     modifier onlyUnhalted() {
18         require(!halted, "Contract is halted");
19         _;
20     }
21 
22     event AccreditationChange(
23         bytes32 provider,
24         bytes32 identifier,
25         bool active
26     );
27 
28     constructor() public {
29         owner = msg.sender;
30         halted = false;
31     }
32 
33     function getAccreditationActive(
34         bytes32 _provider, bytes32 _identifier
35     ) public view returns (bool active_) {
36         return accreditations[_provider][_identifier];
37     }
38     function setAccreditationActive(
39         bytes32 _provider, bytes32 _identifier, bool _active
40     ) public onlyOwner onlyUnhalted {
41         if (accreditations[_provider][_identifier] != _active) {
42             accreditations[_provider][_identifier] = _active;
43             emit AccreditationChange(_provider, _identifier, _active);
44         }
45     }
46 
47     function halt() public onlyOwner {
48         halted = true;
49     }
50     function unhalt() public onlyOwner {
51         halted = false;
52     }
53 
54     function setOwner(address newOwner_) public onlyOwner {
55         owner = newOwner_;
56     }
57 
58     function getRegistryVersion(
59     ) public pure returns (int version) {
60         return 1;
61     }
62 
63     function() public payable {
64         revert("Does not accept a default");
65     }
66 }