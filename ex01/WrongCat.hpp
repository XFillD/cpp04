#include "WrongAnimal.hpp"

class WrongCat: public WrongAnimal
{
	public:
		WrongCat();
		WrongCat(const WrongCat &copyWrCat);

		~WrongCat();

		WrongCat &operator=(const WrongCat &wrcat);

		void makeSound(void)const;
};