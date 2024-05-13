1 pragma solidity ^0.5.0;
2 
3 import "./ERC20Detailed.sol";
4 import "./../../GSN/Context.sol";
5 import "./ERC20.sol";
6 import "./../../../core/cross_chain_manager/interface/IEthCrossChainManagerProxy.sol";
7 
8 contract ERC20Extended is Context, ERC20, ERC20Detailed {
9 
10     address public managerProxyContract; // here managerContract should only be set as the ETH cross chain managing contract address
11     address public operator;    // operator should be the address who deploys this contract, and responsible for 'setManager' and 'bindContractAddrWithChainId'
12     mapping(uint64 => bytes) public bondAssetHashes;
13 
14     event BindAssetHash(uint64 chainId, bytes contractAddr);
15     event SetManagerProxyEvent(address managerContract);
16 
17     
18     modifier onlyManagerContract() {
19         IEthCrossChainManagerProxy ieccmp = IEthCrossChainManagerProxy(managerProxyContract);
20         require(_msgSender() == ieccmp.getEthCrossChainManager(), "msgSender is not EthCrossChainManagerContract");
21         _;
22     }
23 
24     modifier onlyOperator() {
25         require(_msgSender() == operator) ;
26         _;
27     }
28     
29     /* @notice              Mint amount of tokens to the account
30     *  @param account       The account which will receive the minted tokens
31     *  @param amount        The amount of tokens to be minted
32     */
33     function mint(address account, uint256 amount) public onlyManagerContract returns (bool) {
34         _mint(account, amount);
35         return true;
36     }
37     
38     /* @notice              Burn amount of tokens from the msg.sender's balance
39     *  @param amount        The amount of tokens to be burnt
40     */
41     function burn(uint256 amount) public returns (bool) {
42         _burn(_msgSender(), amount);
43         return true;
44     }
45     
46     /* @notice                              Set the ETH cross chain contract as the manager such that the ETH cross chain contract 
47     *                                       will be able to mint tokens to the designated account after a certain amount of tokens
48     *                                       are locked in the source chain
49     *  @param ethCrossChainContractAddr     The ETH cross chain management contract address
50     */
51     function setManagerProxy(address ethCrossChainManagerProxyAddr) onlyOperator public {
52         managerProxyContract = ethCrossChainManagerProxyAddr;
53         emit SetManagerProxyEvent(managerProxyContract);
54     }
55     
56     /* @notice              Bind the target chain with the target chain id
57     *  @param chainId       The target chain id
58     *  @param contractAddr  The specific contract address in bytes format in the target chain
59     */
60     function bindAssetHash(uint64 chainId, bytes memory contractAddr) onlyOperator public {
61         require(chainId != 0, "chainId illegal!");
62         bondAssetHashes[chainId] = contractAddr;
63         emit BindAssetHash(chainId, contractAddr);
64     }
65 }