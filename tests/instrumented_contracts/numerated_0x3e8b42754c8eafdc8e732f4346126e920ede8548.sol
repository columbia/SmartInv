1 pragma solidity ^0.5.0;
2 
3 // Check if we are on Constantinople!
4 // etherguy@mail.com
5 
6 contract HelloWorld{
7     function Hello() public pure returns (string memory){
8         return ("Hello World");
9     }
10 }
11 
12 contract ConstantinopleCheck{
13     
14     address public DeployedContractAddress;
15     
16     function deploy() public {
17         // hex of hello world deploy bytecode
18         bytes memory code = hex'608060405234801561001057600080fd5b50610124806100206000396000f3fe6080604052348015600f57600080fd5b50600436106044577c01000000000000000000000000000000000000000000000000000000006000350463bcdfe0d581146049575b600080fd5b604f60c1565b6040805160208082528351818301528351919283929083019185019080838360005b8381101560875781810151838201526020016071565b50505050905090810190601f16801560b35780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b60408051808201909152600b81527f48656c6c6f20576f726c6400000000000000000000000000000000000000000060208201529056fea165627a7a72305820569c1233dc571997cbd1fa15675cd16b4cacd5615abb6c991dd85a516af1ecc80029';
19         uint len = code.length;
20         address deployed;
21         assembly{
22             deployed := create2(0, add(code, 0x20), len, "Hello Constantinople!")
23         }
24         DeployedContractAddress = deployed;
25     }
26     
27     // returns true if we are on constantinople!
28     function IsItConstantinople() public view returns (bool, bytes32){
29         address target = address(this);
30         bytes32 hash;
31         assembly{
32             hash := extcodehash(target)
33         }
34         
35         // force return hash so the optimizer doesnt skip extcodehash OP
36         return (true, hash);
37     }
38     
39     function Hello() public view returns (string memory) {
40         return (HelloWorld(DeployedContractAddress).Hello());
41     }
42     
43     
44     
45 }