// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity ^0.8.0;

import "../interfaces/ITokenVault.sol";
import "../interfaces/ILockManager.sol";
import "../interfaces/IRevest.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

library RevestHelper {

 
    function boolToString(bool arg) private pure returns (string memory boolean) {
        boolean = arg ? "true" : "false";
    }

    function getLockType(IRevest.LockType lock) private pure returns (string memory lockType) {
        if(lock == IRevest.LockType.TimeLock) {
            lockType = "Time";
        } 
        if(lock == IRevest.LockType.TimeLock) {
            lockType = "Value";
        }
        if(lock == IRevest.LockType.TimeLock) {
            lockType = "Address";
        }
    } 

    function getTicker(address asset) private view returns (string memory ticker) {
        try IERC20Metadata(asset).symbol() returns (string memory tick) {
            ticker = tick;
        } catch {
            ticker = '???';
        }
    }

    function getName(address asset) private view returns (string memory ticker) {
        try IERC20Metadata(asset).name() returns (string memory tick) {
            ticker = tick;
        } catch {
            ticker = 'Unknown Token';
        }
    }

    function amountToDecimal(uint amt, address asset) private view returns (string memory decStr) {
        uint8 decimals;
        try IERC20Metadata(asset).decimals() returns (uint8 dec) {
            decimals = dec;
        } catch {
            decimals = 18;
        }
        decStr = decimalString(amt, decimals);
    }

    function toString(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function decimalString(uint256 number, uint8 decimals) private pure returns(string memory){
        uint256 tenPowDecimals = 10 ** decimals;

        uint256 temp = number;
        uint8 digits;
        uint8 numSigfigs;
        while (temp != 0) {
            if (numSigfigs > 0) {
                // count all digits preceding least significant figure
                numSigfigs++;
            } else if (temp % 10 != 0) {
                numSigfigs++;
            }
            digits++;
            temp /= 10;
        }

        DecimalStringParams memory params;
        if((digits - numSigfigs) >= decimals) {
            // no decimals, ensure we preserve all trailing zeros
            params.sigfigs = number / tenPowDecimals;
            params.sigfigIndex = digits - decimals;
            params.bufferLength = params.sigfigIndex;
        } else {
            // chop all trailing zeros for numbers with decimals
            params.sigfigs = number / (10 ** (digits - numSigfigs));
            if(tenPowDecimals > number){
                // number is less tahn one
                // in this case, there may be leading zeros after the decimal place 
                // that need to be added

                // offset leading zeros by two to account for leading '0.'
                params.zerosStartIndex = 2;
                params.zerosEndIndex = decimals - digits + 2;
                params.sigfigIndex = numSigfigs + params.zerosEndIndex;
                params.bufferLength = params.sigfigIndex;
                params.isLessThanOne = true;
            } else {
                // In this case, there are digits before and
                // after the decimal place
                params.sigfigIndex = numSigfigs + 1;
                params.decimalIndex = digits - decimals + 1;
            }
        }
        params.bufferLength = params.sigfigIndex;
        return generateDecimalString(params);
    }

    // With modifications, the below taken 
    // from https://github.com/Uniswap/uniswap-v3-periphery/blob/main/contracts/libraries/NFTDescriptor.sol#L189-L231

    struct DecimalStringParams {
        // significant figures of decimal
        uint256 sigfigs;
        // length of decimal string
        uint8 bufferLength;
        // ending index for significant figures (funtion works backwards when copying sigfigs)
        uint8 sigfigIndex;
        // index of decimal place (0 if no decimal)
        uint8 decimalIndex;
        // start index for trailing/leading 0's for very small/large numbers
        uint8 zerosStartIndex;
        // end index for trailing/leading 0's for very small/large numbers
        uint8 zerosEndIndex;
        // true if decimal number is less than one
        bool isLessThanOne;
    }

    function generateDecimalString(DecimalStringParams memory params) private pure returns (string memory) {
        bytes memory buffer = new bytes(params.bufferLength);
        if (params.isLessThanOne) {
            buffer[0] = '0';
            buffer[1] = '.';
        }

        // add leading/trailing 0's
        for (uint256 zerosCursor = params.zerosStartIndex; zerosCursor < params.zerosEndIndex; zerosCursor++) {
            buffer[zerosCursor] = bytes1(uint8(48));
        }
        // add sigfigs
        while (params.sigfigs > 0) {
            if (params.decimalIndex > 0 && params.sigfigIndex == params.decimalIndex) {
                buffer[--params.sigfigIndex] = '.';
            }
            buffer[--params.sigfigIndex] = bytes1(uint8(uint256(48) + (params.sigfigs % 10)));
            params.sigfigs /= 10;
        }
        return string(buffer);
    }
}