// Includes
#include "Animal.hpp"

// classes

class Dog: public Animal
{
	private:
		// Private Members

	public:
	// Constructors
		Dog();
		Dog(const Dog &copy);

	// Deconstructors
		~Dog();

	// Overloaded Operators
		Dog &operator=(const Dog &src);

	// Public Methods
		void makeSound(void)const;
	// Getter

	// Setter

};