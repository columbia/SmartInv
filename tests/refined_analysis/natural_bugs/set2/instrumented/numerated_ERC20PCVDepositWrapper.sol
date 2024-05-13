1 pragma solidity ^0.8.4;
2 
3 import "../IPCVDepositBalances.sol";
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 
6 /**
7   @notice a lightweight contract to wrap ERC20 holding PCV contracts
8   @author Fei Protocol
9   When upgrading the PCVDeposit interface, there are many old contracts which do not support it.
10   The main use case for the new interface is to add read methods for the Collateralization Oracle.
11   Most PCVDeposits resistant balance method is simply returning the balance as a pass-through
12   If the PCVDeposit holds FEI it may be considered as protocol FEI
13 
14   This wrapper can be used in the CR oracle which reduces the number of contract upgrades and reduces the complexity and risk of the upgrade
15 */
16 contract ERC20PCVDepositWrapper is IPCVDepositBalances {
17     /// @notice the referenced token deposit
18     address public tokenDeposit;
19 
20     /// @notice the balance reported in token
21     IERC20 public token;
22 
23     /// @notice a flag for whether to report the balance as protocol owned FEI
24     bool public isProtocolFeiDeposit;
25 
26     constructor(
27         address _tokenDeposit,
28         IERC20 _token,
29         bool _isProtocolFeiDeposit
30     ) {
31         tokenDeposit = _tokenDeposit;
32         token = _token;
33         isProtocolFeiDeposit = _isProtocolFeiDeposit;
34     }
35 
36     /// @notice returns total balance of PCV in the Deposit
37     function balance() public view override returns (uint256) {
38         return token.balanceOf(tokenDeposit);
39     }
40 
41     /// @notice returns the resistant balance and FEI in the deposit
42     function resistantBalanceAndFei() public view override returns (uint256, uint256) {
43         uint256 resistantBalance = balance();
44         uint256 reistantFei = isProtocolFeiDeposit ? resistantBalance : 0;
45         return (resistantBalance, reistantFei);
46     }
47 
48     /// @notice display the related token of the balance reported
49     function balanceReportedIn() public view override returns (address) {
50         return address(token);
51     }
52 }
