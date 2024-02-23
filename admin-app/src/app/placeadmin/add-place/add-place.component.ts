import { Component } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { PlaceadminService } from 'src/app/placeadmin.service';

@Component({
  selector: 'app-add-place',
  templateUrl: './add-place.component.html',
  styleUrls: ['./add-place.component.css'],
})
export class AddPlaceComponent {
  constructor(
    private placeadminservice: PlaceadminService,
    private router: Router
  ) {}
  placeForm = new FormGroup({
    Wikipedia: new FormControl(),
    Tags: new FormControl(),
    Latitude: new FormControl(),
    Longitude: new FormControl(),
    Comment: new FormControl(),
    City: new FormControl(),
    Location: new FormControl(),
    Category: new FormControl(),
    Rating:new FormControl(5)
  });

  submit() {
    this.placeadminservice.addPlaces(this.placeForm.value).then((res) => {
      alert('added successfully');
      this.router.navigate(['home']);
    });
  }
}
