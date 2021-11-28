
func withObject<T>(_ object: T, configure: (T) -> Void) -> T {
    configure(object)
    return object
}
