1 pragma solidity ^0.8.4;
2 
3 import "../IPCVDepositBalances.sol";
4 
5 /**
6   @notice a lightweight contract to wrap old PCV deposits to use the new interface 
7   @author Fei Protocol
8   When upgrading the PCVDeposit interface, there are many old contracts which do not support it.
9   The main use case for the new interface is to add read methods for the Collateralization Oracle.
10   Most PCVDeposits resistant balance method is simply returning the balance as a pass-through
11   If the PCVDeposit holds FEI it may be considered as protocol FEI
12 
13   This wrapper can be used in the CR oracle which reduces the number of contract upgrades and reduces the complexity and risk of the upgrade
14 */
15 contract PCVDepositWrapper is IPCVDepositBalances {
16     /// @notice the referenced PCV Deposit
17     IPCVDepositBalances public immutable pcvDeposit;
18 
19     /// @notice the balance reported in token
20     address public immutable token;
21 
22     /// @notice a flag for whether to report the balance as protocol owned FEI
23     bool public immutable isProtocolFeiDeposit;
24 
25     address public constant FEI = 0x956F47F50A910163D8BF957Cf5846D573E7f87CA;
26 
27     constructor(IPCVDepositBalances _pcvDeposit) {
28         pcvDeposit = _pcvDeposit;
29         token = _pcvDeposit.balanceReportedIn();
30         isProtocolFeiDeposit = token == FEI;
31     }
32 
33     /// @notice returns total balance of PCV in the Deposit
34     function balance() public view override returns (uint256) {
35         return pcvDeposit.balance();
36     }
37 
38     /// @notice returns the resistant balance and FEI in the deposit
39     function resistantBalanceAndFei() public view override returns (uint256, uint256) {
40         uint256 resistantBalance = balance();
41         uint256 reistantFei = isProtocolFeiDeposit ? resistantBalance : 0;
42         return (resistantBalance, reistantFei);
43     }
44 
45     /// @notice display the related token of the balance reported
46     function balanceReportedIn() public view override returns (address) {
47         return token;
48     }
49 }
