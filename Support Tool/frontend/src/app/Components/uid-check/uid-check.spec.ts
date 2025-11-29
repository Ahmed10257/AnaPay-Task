import { ComponentFixture, TestBed } from '@angular/core/testing';

import { UidCheck } from './uid-check';

describe('UidCheck', () => {
  let component: UidCheck;
  let fixture: ComponentFixture<UidCheck>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [UidCheck]
    })
    .compileComponents();

    fixture = TestBed.createComponent(UidCheck);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
