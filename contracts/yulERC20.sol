object "Token" {
    code {
        // Store creator of the contract in slot zero
        sstore(0, caller())

        // Deploy the contract
        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, datasize("runtime"))
    }
    object "runtime" {
        code {
            // Protection against sending ether -> all of the functions are non payable 
            // it will get callValue and checks if it is 0
            require(iszero(callvalue()))

            // Dispatcher
            switch selector()
            case 0x70a08231 /** balanceOf(address) */ {
                returnUint(balanceOf(decodeAsAddress(0)))
            }
            case 0x18160ddd /** totalSupply() */ {
                returnUint(totalSupply())
            }
            case 0xa9059cbb /** transfer(address,uint256) */ {
                transfer(decodeAsAddress(0), decodeAsUnit(1))
                returnTrue()
            }
            case 0x23b872dd /** transferFrom(address,address,uint256) */ {
                transferFrom(decodeAsAddress(0), decodeAsAddress(1), decodeAsUint(2))
                returnTrue()
            }
            case 0x095ea7b3 /** approve(address,uint256) */ {
                approve(decodeAsAddress(0), decodeAsUint(1))
                returnTrue()
            }
            case 0xdd62ed3e /** allowance(address,address) */ {
                returnUint(allowance(decodeAsAddress(0), decodeAsAddress(1)))
            }
            case 0x40c10f19 /** mint(address,uint256) */ {
                mint(decodeAsAddress(0), decodeAsUint(1))
                returnTrue()
            }
            default {
                revert(0, 0)
            }

            function mint(account, amount) {
                require(calledByOwner())

                mintTokens(amount)
                addToBalance(account, amount)
                emitTransfer(0, account, amount)
            }

            function transfer(to, amount) {
                executeTransfer(caller(), to, amount)
            }

            function approve(spender, amount) {
                revertIfZeroAddress(spender)
                setAllowance(caller(), spender, amount)
                emitApproval(caller(), spender, amount)
            }

            function transferFrom(from, to, amount) {
                decreaseAllowanceBy(from, caller(), amount)
                executeTransfer(from, to, amount)
            }

            function executeTransfer(from, to, amount) {
                revertIfZeroAddress(to)
                deductFromBalance(from, amount)
                addToBalance(to, amount)
                emitTransfer(from, to, amount)
            }

            /** CALLDATA DECODING FUNCTIONS */
            function selector() -> s {
                s := div(calldataload(0), 0x100000000000000000000000000000000000000000000000000000000)
            }

            function decodeAsAddress(offset) -> v {
                v := decodeAsUint(offset)
                if iszero(iszero(and(v, not(0xffffffffffffffffffffffffffffffffffffffff)))) {
                    revert(0, 0)
                }
            }

            function decodeAsUint(offset) -> v {
                let pos := add(4, mul(offset, 0x20))
                if lt(calldatasize(), add(pos, 0x20)) {
                    revert(0, 0)
                }
                v := calldataload(pos)
            }
            /** CALLDATA ENCODING FUNCTIONS */
        }
    }
}