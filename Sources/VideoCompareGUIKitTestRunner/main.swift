import Foundation
import VideoCompareGUIKit

print("=== VideoCompareGUIKit Test Runner ===")
print()

let failures = SelfTest.run()

if failures.isEmpty {
    print("All tests passed!")
} else {
    print("Failures: \(failures.count)")
    for f in failures {
        print("  - \(f)")
    }
}

exit(failures.isEmpty ? 0 : 1)
