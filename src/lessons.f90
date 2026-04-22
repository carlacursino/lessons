module lessons
  implicit none
  private

  public :: say_hello
contains
  subroutine say_hello
    print *, "Hello, lessons!"
  end subroutine say_hello
end module lessons
