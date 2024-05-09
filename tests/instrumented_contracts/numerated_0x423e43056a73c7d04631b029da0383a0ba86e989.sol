1 pragma solidity 0.4.23;
2 
3 
4 /// @title Version
5 contract Version {
6     string public semanticVersion;
7 
8     /// @notice Constructor saves a public version of the deployed Contract.
9     /// @param _version Semantic version of the contract.
10     constructor(string _version) internal {
11         semanticVersion = _version;
12     }
13 }
14 
15 
16 /// @title Factory
17 contract Factory is Version {
18     event FactoryAddedContract(address indexed _contract);
19 
20     modifier contractHasntDeployed(address _contract) {
21         require(contracts[_contract] == false);
22         _;
23     }
24 
25     mapping(address => bool) public contracts;
26 
27     constructor(string _version) internal Version(_version) {}
28 
29     function hasBeenDeployed(address _contract) public constant returns (bool) {
30         return contracts[_contract];
31     }
32 
33     function addContract(address _contract)
34         internal
35         contractHasntDeployed(_contract)
36         returns (bool)
37     {
38         contracts[_contract] = true;
39         emit FactoryAddedContract(_contract);
40         return true;
41     }
42 }
43 
44 
45 contract PaymentAddress {
46     event PaymentMade(address indexed _payer, address indexed _collector, uint256 _value);
47 
48     address public collector;
49 
50     constructor(address _collector) public {
51         collector = _collector;
52     }
53 
54     function () public payable {
55         emit PaymentMade(msg.sender, collector, msg.value);
56         collector.transfer(msg.value);
57     }
58 }
59 
60 
61 contract PaymentAddressFactory is Factory {
62     // index of created contracts
63     mapping (address => address[]) public paymentAddresses;
64 
65     constructor() public Factory("1.0.0") {}
66 
67     // deploy a new contract
68     function newPaymentAddress(address _collector)
69         public
70         returns(address newContract)
71     {
72         PaymentAddress paymentAddress = new PaymentAddress(_collector);
73         paymentAddresses[_collector].push(paymentAddress);
74         addContract(paymentAddress);
75         return paymentAddress;
76     }
77 }